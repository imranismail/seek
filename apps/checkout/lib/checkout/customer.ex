defmodule Checkout.Customer do
  use Checkout.Schema

  schema "customers" do
    field :slug, :string
    field :name, :string
    field :cart, :map, virtual: true

    many_to_many :price_rules, PriceRule, join_through: CustomerPriceRule

    timestamps()
  end

  def search(query) do
    from q in __MODULE__, where: ilike(q.name , ^"%#{query}%")
  end

  def exclude(queryable, ids) when is_list(ids) do
    from q in queryable, where: q.id not in ^ids
  end

  def select(queryable, schema \\ :default)
  def select(queryable, schema) when schema in [:default, "default"] do
    Repo.all(queryable)
  end
  def select(queryable, schema) when schema in [:option, "option"] do
    Repo.all(from q in queryable, select: %{label: q.name, value: q.id})
  end

  def to_session_id(customer) do
    "customer:#{customer.id}"
  end

  def from_session_id(session_id) do
    case session_id do
      "customer:" <> id -> find(id)
      nil -> nil
    end
  end

  def load_cart(customer) do
    Map.put(customer, :cart, Cart.find_or_create(customer.id))
  end

  def clear_cart(customer) do
    Cart.delete(customer.id)
    load_cart(customer)
  end

  def load_price_rules(customer_or_customers) do
    Repo.preload(customer_or_customers, :price_rules)
  end

  def add_item(customer, product) do
    cart = Map.put(customer.cart, :items, customer.cart.items ++ [product])
    Cart.update(customer.id, cart)
    Map.put(customer, :cart, cart)
  end

  def checkout(customer) do
    Checkout.new()
    |> Checkout.set_customer(customer)
    |> Checkout.set_items(customer.cart.items)
    |> Checkout.set_price_rules(PriceRule.all())
    |> Checkout.calculate()
  end
end
