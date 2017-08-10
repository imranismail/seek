defmodule Web.API.CustomerController do
  use Web, :controller

  plug :scrub_params, "filter" when action == :index

  def index(conn, %{"filter" => filter}) do
    json(
      conn,
      filter["query"]
      |> Customer.search()
      |> Customer.exclude(filter["exclude"] || [])
      |> Customer.select(filter["schema"])
    )
  end
end
