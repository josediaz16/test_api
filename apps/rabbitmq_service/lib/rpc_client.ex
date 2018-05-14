defmodule RabbitmqService.RpcClient do
  use GenServer
  use AMQP

  def start_link(queue_name: queue_name, client_name: client_name) do
    GenServer.start_link(__MODULE__, queue_name, name: client_name)
  end

  def init(queue_name) do
    {:ok, conn} = Connection.open(host: "rabbitmq")
    {:ok, channel} = Channel.open(conn)

    {:ok, %{queue: callback_queue}} = Queue.declare(channel, "", exclusive: true)
    {:ok, {channel, queue_name, callback_queue}}
  end

  def push_job(client_name, payload) do
    GenServer.call(client_name, {:push_job, payload})
  end

  def handle_call({:push_job, payload}, _from, state) do
    {:reply, push_to_queue(payload, state), state}
  end

  def handle_info({:basic_consume_ok, _}, state) do
    {:noreply, state} 
  end

  def push_to_queue(payload, {channel, queue_name, callback_queue}) do
    Basic.consume(channel, callback_queue, nil, no_ack: false)
    correlation_id = get_correlation_id()
    {:ok, str_payload} = payload
      |> Poison.encode

    Basic.publish(channel, "", queue_name, str_payload, reply_to: callback_queue, correlation_id: correlation_id)
    wait_for_messages(channel, correlation_id)
  end

  defp get_correlation_id do
    :erlang.unique_integer
      |> :erlang.integer_to_binary
      |> Base.encode64
  end

  defp wait_for_messages(_channel, correlation_id) do
    receive do
      {:basic_deliver, payload, %{correlation_id: ^correlation_id}} ->
        {:ok, message} = Poison.decode(payload)
        message
    end
  end
end
