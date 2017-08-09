defmodule Checkout.PriceRule do
  use Checkout, :schema

  schema "price_rules" do
    field :value, :integer
    field :usage_limit, :integer
    field :application_method, :string
    field :prerequisite_qty_range, :integer
    field :prerequisite_qty_range_comparison_operator, :string

    has_many :entitled_customers, Checkout.Customer
    has_many :entitled_products, Checkout.Products

    timestamps()
  end
end
