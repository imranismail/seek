defmodule Checkout do
  @moduledoc """
  Checkout keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use Checkout.Schema

  embedded_schema do
    field :total, :integer, default: 0

    embeds_one :customer, Checkout.Customer
    embeds_many :items, Checkout.Product
    embeds_many :price_rules, Checkout.PriceRule
    embeds_many :applied_price_rules, Checkout.PriceRule

    timestamps()
  end

  def calculate_total(checkout) do
    checkout
    |> calculate_sub_total()
    |> apply_price_rules()
  end

  defp calculate_sub_total(checkout) do
    checkout
    |> Map.fetch!(:items)
    |> Enum.reduce(checkout, &(%{&2 | total: &2.total + &1.price}))
  end

  defp apply_price_rules(checkout) do
    checkout
    |> Map.fetch!(:price_rules)
    |> Enum.reduce(checkout, &PriceRule.apply_to/2)
  end
end
