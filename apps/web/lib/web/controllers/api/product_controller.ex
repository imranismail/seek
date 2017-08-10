defmodule Web.API.ProductController do
  use Web, :controller

  plug :scrub_params, "filter" when action == :index

  def index(conn, %{"filter" => filter}) do
    json(
      conn,
      filter["query"]
      |> Product.search()
      |> Product.exclude(filter["exclude"] || [])
      |> Product.select(filter["schema"])
    )
  end
end
