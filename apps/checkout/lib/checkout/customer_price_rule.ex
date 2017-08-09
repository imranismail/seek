defmodule Checkout.CustomerPriceRule do
  use Checkout.Schema

  schema "customer_price_rules" do
    belongs_to :customer, Customer
    belongs_to :price_rule, PriceRule

    timestamps()
  end
end
