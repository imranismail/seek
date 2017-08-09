defmodule Checkout.PriceRuleTest do
  use ExUnit.Case
  doctest Checkout.PriceRule

  alias Checkout.{Customer, PriceRule, Product}

  test "PriceRule.apply_to/2" do
    product    = Product.new(id: "classic", price: 549_99)
    customer   = Customer.new(id: "microsoft", name: "Microsoft")
    price_rule = PriceRule.new(
      value: -1000,
      entitled_customers: [customer],
      entitled_products: [product],
      application_method: :across
    )

    checkout = Checkout.new(items: [product])
    checkout = PriceRule.apply_to(price_rule, checkout)
    checkout = Checkout.calculate_total(checkout)

    assert price_rule not in checkout.applied_price_rules
    assert checkout.total == product.price

    checkout = Checkout.new(customer: customer, items: [product])
    checkout = PriceRule.apply_to(price_rule, checkout)
    checkout = Checkout.calculate_total(checkout)

    assert price_rule in checkout.applied_price_rules
    assert checkout.total == (product.price + price_rule.value)
  end
end
