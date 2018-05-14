defmodule UsersService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      UsersService.Repo,
      {RabbitmqService.RpcServer, [queue_name: "users_queue", server_name: :users_server, handler: &UsersService.UserManager.create/1]}
      # Starts a worker by calling: UsersService.Worker.start_link(arg)
      # {UsersService.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UsersService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
