defmodule Checkout.PriceRuleTest do
  use ExUnit.Case
  doctest Checkout.PriceRule

  alias Checkout.{Customer, PriceRule, Product}

  setup_all do
    product  = Product.new(id: "classic", price: 549_99)
    customer = Customer.new(id: "microsoft", name: "Microsoft")
    price_rule = PriceRule.new(
      value: -1000,
      entitled_customers: [customer],
      entitled_products: [product],
      application_method: :across
    )

    {:ok, product: product, price_rule: price_rule, customer: customer}
  end

  test "PriceRule.apply_to/2 doesn't apply when requirements are unsatisfied", state do
    checkout = Checkout.new(customer: :default, items: [state[:product]])
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate_total(checkout)

    assert price_rule not in checkout.applied_price_rules
    assert checkout.total == product.price
  end

  test "PriceRule.apply_to/2 should apply when requirements are satisfied", state do
    checkout = Checkout.new(customer: state[:customer], items: [state[:product]])
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate_total(checkout)

    assert state[:price_rule] in checkout.applied_price_rules
    assert checkout.total == (state[:product].price + state[:price_rule].value)
  end
end
