use Mix.Config

# Configure your database
config :checkout, Checkout.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "checkout_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
