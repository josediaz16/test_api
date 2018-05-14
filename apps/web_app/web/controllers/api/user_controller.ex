defmodule WebApp.Api.UserController do
  use WebApp.Web, :controller
  alias RabbitmqService.RpcClient

  def create(conn, %{"user" => user_params}) do
    response = RpcClient.push_job(:users_client, user_params)
    case response do
      %{"success" => true, "user" => user} ->
        conn
        |> put_status(:created)
        |> json(user)
      %{"success" => false, "errors" => errors} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end
end
