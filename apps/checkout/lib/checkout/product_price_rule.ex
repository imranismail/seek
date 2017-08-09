defmodule Checkout.ProductPriceRule do
  use Checkout.Schema

  schema "products_price_rules" do
    belongs_to :product, Product
    belongs_to :price_rule, PriceRule

    timestamps()
  end
end
