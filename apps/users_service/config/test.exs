use Mix.Config

config :users_service, UsersService.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "users_service_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
