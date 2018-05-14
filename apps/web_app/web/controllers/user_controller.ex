defmodule WebApp.UserController do
  use WebApp.Web, :controller
  alias RabbitmqService.RpcClient

  def new(conn, _params) do
    changeset = %{}
    render conn, changeset: changeset, errors: []
  end

  def create(conn, %{"user" => user_params}) do
    response = RpcClient.push_job(:users_client, user_params)
    case response do
      %{"success" => true, "user" => _user} ->
        conn
        |> put_flash(:info, "The user was created successfully")
        |> redirect(to: "/")
      %{"success" => false, "errors" => errors} ->
        conn
        |> put_flash(:error, "Unable to create user")
        |> render("new.html", changeset: user_params, errors: errors)
    end
  end
end
