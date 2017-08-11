defmodule Checkout.Repo do
  use Ecto.Repo, otp_app: :checkout

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    username = System.get_env("POSTGRES_USER") || opts[:username]
    password = System.get_env("POSTGRES_PASSWORD") || opts[:password]
    hostname = System.get_env("POSTGRES_HOST") || opts[:hostname]
    database = System.get_env("POSTGRES_DATABASE") || opts[:database]

    {:ok,
      opts
      |> Keyword.put(:username, username)
      |> Keyword.put(:password, password)
      |> Keyword.put(:hostname, hostname)
      |> Keyword.put(:database, database)
    }
  end
end
