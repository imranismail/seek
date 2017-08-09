defmodule Checkout.Customer do
  use Checkout.Schema

  schema "customers" do
    field :slug, :string
    field :name, :string

    many_to_many :price_rules, PriceRule, join_through: CustomerPriceRule

    timestamps()
  end
end
