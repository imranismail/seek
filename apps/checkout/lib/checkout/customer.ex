defmodule Checkout.Customer do
  use Checkout, :schema

  schema "customers" do
    field :slug, :string
    field :name, :string

    belongs_to :price_rule, Checkout.PriceRule

    timestamps()
  end
end
