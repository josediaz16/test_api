defmodule RabbitmqService.RpcServer do
  use GenServer
  use AMQP

  def start_link(handler) do
    GenServer.start_link(__MODULE__, handler, name: :rpc_server)
  end

  def init(handler) do
    {:ok, conn} = Connection.open(host: "rabbitmq")
    {:ok, channel} = Channel.open(conn)

    Queue.declare(channel, "rpc_queue")
    Basic.qos(channel, prefetch_count: 1)
    Basic.consume(channel, "rpc_queue")

    {:ok, {channel, handler}}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, metadata}, {channel, handler}) do
    {:ok, str_payload} = payload
      |> Poison.decode

    {:ok, response} = str_payload
      |> handler.()
      |> Poison.encode

    Basic.publish(channel, "", metadata.reply_to, response, correlation_id: metadata.correlation_id)
    Basic.ack(channel, metadata.delivery_tag)

    {:noreply, {channel, handler}}
  end

  def handle_info({:basic_consume_ok, _}, state) do
    {:noreply, state} 
  end
end
