defmodule Checkout.PriceRuleTest do
  use ExUnit.Case
  doctest Checkout.PriceRule

  alias Checkout.{Customer, PriceRule, Product}

  setup_all do
    product  = Product.new(id: 1, sku: "classic", price: 549_99)
    microsoft = Customer.new(id: 1, slug: "microsoft", name: "Microsoft")
    default = Customer.new(id: 2, slug: "default", name: "Default")
    price_rule = PriceRule.new(
      value: -1000,
      entitled_customers: [microsoft],
      entitled_products: [product],
      preq_qty: 1,
      preq_qty_operator: ">",
      application_method: "across"
    )

    {:ok,
      product: product,
      price_rule: price_rule,
      microsoft: microsoft,
      default: default}
  end

  test "PriceRule.apply_to/2 doesn't apply when customer is not entitled", state do
    checkout = Checkout.new(customer: state[:default], items: [state[:product]])
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate(checkout)

    assert state[:price_rule] not in checkout.applied_price_rules
    assert checkout.total == state[:product].price
  end

  test "PriceRule.apply_to/2 should apply when preq_qty is satisfied", state do
    checkout = Checkout.new(
      customer: state[:microsoft],
      items: [state[:product], state[:product]]
    )
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate(checkout)

    assert state[:price_rule] in checkout.applied_price_rules
    assert checkout.total == state[:product].price * 2 + state[:price_rule].value
  end

  test "PriceRule.apply_to/2 shouldn't apply when preq_qty isn't satisfied", state do
    checkout = Checkout.new(customer: state[:microsoft], items: [state[:product]])
    checkout = PriceRule.apply_to(state[:price_rule], checkout)
    checkout = Checkout.calculate(checkout)

    assert state[:price_rule] not in checkout.applied_price_rules
    assert checkout.total == state[:product].price
  end
end
