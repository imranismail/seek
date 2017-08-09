defmodule Checkout.Product do
  use Checkout.Schema

  schema "products" do
    field :sku, :string
    field :name, :string
    field :price, :integer

    many_to_many :price_rules, PriceRule, join_through: ProductPriceRule

    timestamps()
  end
end
