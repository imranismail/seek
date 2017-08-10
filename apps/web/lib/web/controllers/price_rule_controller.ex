defmodule Web.PriceRuleController do
  use Web, :controller

  plug :load_price_rules when action == :index
  plug :scrub_params, "price_rule" when action == :create

  def index(conn, _params) do
    render(conn)
  end

  def new(conn, _params) do
    price_rule = PriceRule.preload(%PriceRule{})
    render(conn, changeset: PriceRule.changeset(price_rule))
  end

  def create(conn, %{"price_rule" => price_rule_params}) do
    price_rule = PriceRule.preload(%PriceRule{})
    changeset = PriceRule.changeset(price_rule, price_rule_params)

    case Repo.insert(changeset) do
      {:ok, price_rule} ->
        conn
        |> put_flash(:normal, "Price rule: #{price_rule.name} created")
        |> redirect(to: price_rule_path(conn, :index))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    price_rule = PriceRule.preload(PriceRule.find!(id))
    render(conn, :edit, changeset: PriceRule.changeset(price_rule))
  end

  def delete(conn, %{"id" => id}) do
    price_rule = PriceRule.find!(id)
    Repo.delete!(price_rule)

    redirect(conn, to: price_rule_path(conn, :index))
  end

  defp load_price_rules(conn, _opts) do
    preloads = [:entitled_customers, :entitled_products]
    price_rules = Repo.preload(PriceRule.all(), preloads)
    assign(conn, :price_rules, price_rules)
  end
end
