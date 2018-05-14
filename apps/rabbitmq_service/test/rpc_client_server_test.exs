defmodule RabbitmqRpcClientServerTest do
  use ExUnit.Case
  alias RabbitmqService.RpcServer
  alias RabbitmqService.RpcClient

  def dummy_function(payload) do
    %{success: true, payload: payload}
  end

  test "It sends a message from a producer to a consumer and gets a response in a callback queue" do
    RpcServer.start_link(&dummy_function/1)
    RpcClient.start_link

    {:ok, payload} = %{name: "Ross", job: "Dinosaurs"}
      |> Poison.encode

    response = RpcClient.push_job(payload)

    assert response == %{
      "success" => true,
      "payload" => %{
        "name" => "Ross",
        "job" => "Dinosaurs"
      }
    }
  end
end
