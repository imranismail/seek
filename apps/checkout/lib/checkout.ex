defmodule Checkout do
  @moduledoc """
  Checkout keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use Checkout.Schema

  embedded_schema do
    field :subtotal, :integer, default: 0
    field :total, :integer, default: 0
    field :discount, :integer, default: 0

    embeds_one :customer, Customer
    embeds_many :items, Product
    embeds_many :price_rules, PriceRule
    embeds_many :applied_price_rules, PriceRule

    timestamps()
  end

  def set_customer(checkout, customer) do
    %{checkout | customer: customer}
  end

  def set_items(checkout, items) do
    %{checkout | items: items}
  end

  def set_price_rules(checkout, price_rules) do
    %{checkout | price_rules: price_rules}
  end

  def add_item(checkout, product) do
    %{checkout | items: checkout.items ++ [product]}
  end

  def add_price_rule(checkout, price_rule) do
    %{checkout | price_rules: checkout.price_rules ++ [price_rule]}
  end

  def calculate(checkout) do
    checkout
    |> calculate_sub_total()
    |> apply_price_rules()
  end

  defp calculate_sub_total(checkout) do
    checkout
    |> Map.fetch!(:items)
    |> Enum.reduce(checkout, fn item, checkout ->
      checkout
      |> Map.put(:subtotal, checkout.subtotal + item.price)
      |> Map.put(:total, checkout.total + item.price)
    end)
  end

  defp apply_price_rules(checkout) do
    checkout
    |> Map.fetch!(:price_rules)
    |> Repo.preload([:entitled_customers, :entitled_products])
    |> Enum.reduce(checkout, &PriceRule.apply_to/2)
  end
end
