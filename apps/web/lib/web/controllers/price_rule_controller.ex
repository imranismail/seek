defmodule Web.PriceRuleController do
  use Web, :controller

  plug :load_price_rules when action == :index

  def index(conn, _params) do
    render(conn)
  end

  def new(conn, _params) do
    render(conn, changeset: PriceRule.changeset(%PriceRule{}))
  end

  defp load_price_rules(conn, _opts) do
    preloads = [:entitled_customers, :entitled_products]
    price_rules = Repo.preload(PriceRule.all(), preloads)
    assign(conn, :price_rules, price_rules)
  end
end
