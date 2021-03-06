use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web_app, WebApp.Endpoint,
  http: [port: 4001],
  server: false

config :phoenix_integration,
  endpoint: WebApp.Endpoint

# Print only warnings and errors during test
config :logger, level: :warn
