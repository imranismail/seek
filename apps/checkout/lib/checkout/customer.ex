defmodule Checkout.Customer do
  use Checkout.Schema

  schema "customers" do
    field :slug, :string
    field :name, :string
    field :cart, :map, virtual: true

    many_to_many :price_rules, PriceRule, join_through: CustomerPriceRule

    timestamps()
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
