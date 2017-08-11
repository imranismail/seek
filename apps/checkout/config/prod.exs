use Mix.Config

config :checkout, Checkout.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: 10

# import_config "prod.secret.exs"
