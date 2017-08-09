use Mix.Config

config :checkout, ecto_repos: [Checkout.Repo]

import_config "#{Mix.env}.exs"
