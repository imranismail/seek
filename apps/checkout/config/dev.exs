use Mix.Config

# Configure your database
config :checkout, Checkout.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "checkout_dev",
  hostname: "localhost",
  pool_size: 10
