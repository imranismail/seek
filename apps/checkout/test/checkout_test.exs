defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  alias Checkout.{Customer, Product, PriceRule}

  test "Checkout.set_customer/2" do
    customer = Customer.new()
    checkout = Checkout.set_customer(Checkout.new, customer)

    assert checkout.customer == customer
  end

  test "Checkout.add_item/2" do
    product  = Product.new()
    checkout = Checkout.add_item(Checkout.new, product)

    assert product in checkout.items
  end

  test "Checkout.add_price_rule/2" do
    price_rule = PriceRule.new()
    checkout   = Checkout.add_price_rule(Checkout.new, price_rule)

    assert price_rule in checkout.price_rules
  end

  test "Checkout.total/1" do
    product    = Product.new(sku: "classic", price: 549_99)
    price_rule = PriceRule.new(value: -1000, application_method: "across")

    checkout =
      Checkout.new()
      |> Checkout.add_item(product)
      |> Checkout.calculate()

    assert checkout.total == 549_99

    checkout =
      Checkout.new()
      |> Checkout.add_item(product)
      |> Checkout.add_price_rule(price_rule)
      |> Checkout.calculate()

    assert checkout.total == 539_99
  end
end
