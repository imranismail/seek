defmodule Checkout.Product do
  use Checkout.Schema

  schema "products" do
    field :sku, :string
    field :name, :string
    field :price, :integer

    belongs_to :price_rule, Checkout.PriceRule

    timestamps()
  end
end
