defmodule Checkout.PriceRule do
  use Checkout.Schema

  schema "price_rules" do
    field :value, :integer
    field :usage_limit, :integer
    field :application_method, :string
    field :prerequisite_qty_range, :integer
    field :prerequisite_qty_range_comparison_operator, :string

    many_to_many :entitled_customers, Customer, join_through: CustomerPriceRule
    many_to_many :entitled_products, Product, join_through: ProductPriceRule

    timestamps()
  end

  def apply_to(price_rule, checkout) do
    if apply?(price_rule, checkout) do
      do_apply_to(price_rule, checkout)
    else
      checkout
    end
  end

  defp apply?(price_rule, checkout) do
    entitled_customer?(price_rule, checkout)
    and not exceed_usage_limit?(price_rule, checkout)
    and satisfied_prerequisite_qty_range?(price_rule, checkout)
  end

  defp entitled_customer?(price_rule, checkout) do
    price_rule = Repo.preload(price_rule, :entitled_customers)

    if Enum.any?(price_rule.entitled_customers) do
      checkout.customer in price_rule.entitled_customers
    else
      true
    end
  end

  defp entitled_products?(price_rule, product) do
    price_rule = Repo.preload(price_rule, :entitled_products)

    if Enum.any?(price_rule.entitled_products) do
      product in price_rule.entitled_products
    else
      true
    end
  end

  defp exceed_usage_limit?(price_rule, checkout) do
    checkout
    |> Map.fetch!(:applied_price_rules)
    |> Enum.filter(&(&1 == price_rule))
    |> Enum.count()
    |> Kernel.>=(price_rule.usage_limit)
  end

  defp satisfied_prerequisite_qty_range?(price_rule, checkout) do
    count =
      checkout.items
      |> Enum.filter(&entitled_products?(price_rule, &1))
      |> Enum.count()

    case price_rule.prerequisite_qty_range_comparison_operator do
      "gt" -> count > price_rule.prerequisite_qty_range
      "eq" -> count == price_rule.prerequisite_qty_range
      "lt" -> count < price_rule.prerequisite_qty_range
      nil  -> true
    end
  end

  defp do_apply_to(price_rule, checkout) do
    case price_rule.application_method do
      "across" ->
        %{checkout |
          total: checkout.total + price_rule.value,
          applied_price_rules: checkout.applied_price_rules ++ [price_rule]
        }
      "each" ->
        checkout.items
        |> Enum.filter(&(&1 in price_rule.entitled_products))
        |> Enum.reduce(checkout, fn _item, checkout ->
          %{checkout |
            total: checkout.total + price_rule.value,
            applied_price_rules: checkout.applied_price_rules ++ [price_rule]
          }
        end)
    end
  end
end
