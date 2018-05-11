use Mix.Config

config :users_service, UsersService.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "users_service_repo",
  username: "postgres",
  password: "postgres",
  hostname: "postgres"
