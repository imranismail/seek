defmodule SeekTest do
  use ExUnit.Case

  alias Checkout.{Customer, PriceRule, Product}

  setup_all do
    classic = Product.new(id: 1, sku: "classic", name: "Classic Ad", price: 269_99)
    standout = Product.new(id: 2, sku: "standout", name: "Standout Ad", price: 322_99)
    premium  = Product.new(id: 2, sku: "premium", name: "Premium Ad", price: 394_99)

    unilever = Customer.new(id: 1, slug: "unilever", name: "Unilever")
    apple = Customer.new(id: 2, slug: "apple", name: "Apple")
    nike = Customer.new(id: 3, slug: "nike", name: "Nike")
    ford = Customer.new(id: 4, slug: "ford", name: "Ford")
    default = Customer.new(id: 5, slug: "default", name: "Default")

    price_rule_unilever = PriceRule.new(
      id: 1,
      value: -classic.price,
      entitled_customers: [unilever],
      entitled_products: [classic],
      preq_qty: 3,
      preq_qty_operator: "greater_than_or_equal_to",
      usage_limit: 1,
      application_method: "across"
    )

    price_rule_apple = PriceRule.new(
      id: 2,
      value: -(standout.price - 299_99),
      entitled_customers: [apple],
      entitled_products: [standout],
      application_method: "each"
    )

    price_rule_nike = PriceRule.new(
      id: 3,
      value: -(premium.price - 379_99),
      entitled_customers: [nike],
      entitled_products: [premium],
      preq_qty: 2,
      preq_qty_operator: "greater_than_or_equal_to",
      application_method: "each"
    )

    price_rule_ford_classic = PriceRule.new(
      id: 4,
      value: -classic.price,
      entitled_customers: [ford],
      entitled_products: [classic],
      preq_qty: 5,
      preq_qty_operator: "greater_than_or_equal_to",
      usage_limit: 1,
      application_method: "across"
    )

    price_rule_ford_standout = PriceRule.new(
      id: 5,
      value: -(standout.price - 309_99),
      entitled_customers: [ford],
      entitled_products: [standout],
      application_method: "each"
    )

    price_rule_ford_premium = PriceRule.new(
      id: 6,
      value: -(premium.price - 389_99),
      entitled_customers: [ford],
      entitled_products: [premium],
      preq_qty: 3,
      preq_qty_operator: "greater_than_or_equal_to",
      application_method: "each"
    )

    checkout =
      Checkout.new
      |> Checkout.add_price_rule(price_rule_unilever)
      |> Checkout.add_price_rule(price_rule_apple)
      |> Checkout.add_price_rule(price_rule_nike)
      |> Checkout.add_price_rule(price_rule_ford_classic)
      |> Checkout.add_price_rule(price_rule_ford_standout)
      |> Checkout.add_price_rule(price_rule_ford_premium)

    {:ok,
      checkout: checkout,
      customers: [
        unilever: unilever,
        ford: ford,
        apple: apple,
        nike: nike,
        default: default,
      ],
      products: [
        classic: classic,
        standout: standout,
        premium: premium
      ]
    }
  end

  test "Checkout [classic, standout, premium] for default", state do
    checkout =
      state[:checkout]
      |> Checkout.set_customer(state[:customers][:default])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:standout])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.calculate()

    assert checkout.total == 987_97
  end

  test "Checkout [classic, classic, premium] for unilever", state do
    checkout =
      state[:checkout]
      |> Checkout.set_customer(state[:customers][:unilever])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.calculate()

    assert checkout.total == 934_97
  end

  test "Checkout [standout, standout, standout, premium] for apple", state do
    checkout =
      state[:checkout]
      |> Checkout.set_customer(state[:customers][:apple])
      |> Checkout.add_item(state[:products][:standout])
      |> Checkout.add_item(state[:products][:standout])
      |> Checkout.add_item(state[:products][:standout])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.calculate()

    assert checkout.total == 1294_96
  end

  test "Checkout [premium, premium, premium, premium] for nike", state do
    checkout =
      state[:checkout]
      |> Checkout.set_customer(state[:customers][:nike])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.calculate()

    assert checkout.total == 1519_96
  end

  test "Checkout [classic, classic, classic, classic, classic, standout, premium, premium, premium] for ford", state do
    checkout =
      state[:checkout]
      |> Checkout.set_customer(state[:customers][:ford])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:classic])
      |> Checkout.add_item(state[:products][:standout])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.add_item(state[:products][:premium])
      |> Checkout.calculate()

    assert checkout.total == 2559_92
  end
end
