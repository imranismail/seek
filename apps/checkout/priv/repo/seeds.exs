# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Checkout.Repo.insert!!(%Checkout.SomeSchema{})
#
# We recommend using the bang functions (`insert!!`, `update!`
# and so on) as they will fail if something goes wrong.

use Checkout.Shared

classic = Repo.insert! Product.new(
  sku: "classic",
  name: "Classic Ad",
  price: 269_99
)

standout = Repo.insert! Product.new(
  sku: "standout",
  name: "Standout Ad",
  price: 322_99
)

premium = Repo.insert! Product.new(
  sku: "premium",
  name: "Premium Ad",
  price: 394_99
)

unilever = Repo.insert! Customer.new(
  slug: "unilever",
  name: "Unilever"
)

apple = Repo.insert! Customer.new(
  slug: "apple",
  name: "Apple"
)

nike = Repo.insert! Customer.new(
  slug: "nike",
  name: "Nike"
)

ford = Repo.insert! Customer.new(
  slug: "ford",
  name: "Ford"
)

Repo.insert! PriceRule.new(
  value: -classic.price,
  entitled_customers: [unilever],
  entitled_products: [classic],
  preq_qty: 3,
  preq_qty_operator: "==",
  usage_limit: 1,
  application_method: "across"
)

Repo.insert! PriceRule.new(
  value: -(standout.price - 299_99),
  entitled_customers: [apple],
  entitled_products: [standout],
  application_method: "each"
)

Repo.insert! PriceRule.new(
  value: -(premium.price - 379_99),
  entitled_customers: [nike],
  entitled_products: [premium],
  preq_qty: 2,
  preq_qty_operator: ">=",
  application_method: "each"
)

Repo.insert! PriceRule.new(
  value: -classic.price,
  entitled_customers: [ford],
  entitled_products: [classic],
  preq_qty: 5,
  preq_qty_operator: "==",
  usage_limit: 1,
  application_method: "across"
)

Repo.insert! PriceRule.new(
  value: -(standout.price - 309_99),
  entitled_customers: [ford],
  entitled_products: [standout],
  application_method: "each"
)

Repo.insert! PriceRule.new(
  value: -(premium.price - 389_99),
  entitled_customers: [ford],
  entitled_products: [premium],
  preq_qty: 3,
  preq_qty_operator: ">=",
  application_method: "each"
)
