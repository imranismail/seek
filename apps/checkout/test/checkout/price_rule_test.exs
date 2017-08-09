defmodule Checkout.PriceRuleTest do
  use ExUnit.Case
  doctest Checkout.PriceRule

  alias Checkout.{Customer, PriceRule, Product}

  setup_all do
    product  = Product.new(sku: "classic", price: 549_99)
    customer = Customer.new(slug: "microsoft", name: "Microsoft")
    price_rule = PriceRule.new(
      value: -1000,
      entitled_customers: [customer],
      entitled_products: [product],
      prerequisite_qty_range: 1,
      prerequisite_qty_range_comparison: "gt",
      application_method: "across"
    )

    {:ok, product: product, price_rule: price_rule, customer: customer}
  end

  test "PriceRule.apply_to/2 doesn't apply when customer is not entitled", state do
    checkout = Checkout.new(customer: :default, items: [state[:product]])
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate_total(checkout)

    assert state[:price_rule] not in checkout.applied_price_rules
    assert checkout.total == state[:product].price
  end

  test "PriceRule.apply_to/2 doesn't apply when qty prerequisites are satisfied", state do
    checkout = Checkout.new(
      customer: state[:customer],
      items: [state[:product], state[:product]]
    )
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate_total(checkout)

    assert state[:price_rule] in checkout.applied_price_rules
    assert checkout.total == state[:product].price * 2 + state[:price_rule].value
  end

  test "PriceRule.apply_to/2 should apply when requirements are not satisfied", state do
    checkout = Checkout.new(customer: state[:customer], items: [state[:product]])
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate_total(checkout)

    assert state[:price_rule] not in checkout.applied_price_rules
    assert checkout.total == state[:product].price
  end
end
