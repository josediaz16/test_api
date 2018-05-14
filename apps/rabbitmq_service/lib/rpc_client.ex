defmodule RabbitmqService.RpcClient do
  use GenServer
  use AMQP

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :rpc_client)
  end

  def init(_opts) do
    {:ok, conn} = Connection.open(host: "rabbitmq")
    {:ok, channel} = Channel.open(conn)

    {:ok, %{queue: queue_name}} = Queue.declare(channel, "", exclusive: true)
    {:ok, {channel, queue_name}}
  end

  def push_job(payload) do
    GenServer.call(:rpc_client, {:push_job, payload})
  end

  def handle_call({:push_job, payload}, _from, state) do
    {:reply, cosito(payload, state), state}
  end

  def handle_info({:basic_consume_ok, _}, state) do
    {:noreply, state} 
  end

  def cosito(payload, {channel, queue_name}) do
    Basic.consume(channel, queue_name, nil, no_ack: false)
    correlation_id = get_correlation_id()

    Basic.publish(channel, "", "rpc_queue", payload, reply_to: queue_name, correlation_id: correlation_id)
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
