defmodule RabbitmqService.RpcServer do
  use GenServer
  use AMQP

  def start_link(queue_name: queue_name, server_name: server_name, handler: handler) do
    GenServer.start_link(__MODULE__, {queue_name, handler}, name: server_name)
  end

  def init({queue_name, handler}) do
    {:ok, conn} = Connection.open(host: "rabbitmq")
    {:ok, channel} = Channel.open(conn)

    Queue.declare(channel, queue_name)
    Basic.qos(channel, prefetch_count: 1)
    Basic.consume(channel, queue_name)

    {:ok, {channel, handler}}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
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
