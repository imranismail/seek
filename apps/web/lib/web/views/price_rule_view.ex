defmodule Web.PriceRuleView do
  use Web, :view

  def comparison_operators do
    Checkout.PriceRule.comparison_operators()
    |> Enum.map(fn operator ->
      label =
        operator
        |> String.replace("_", " ")
        |> String.capitalize()

      {label, operator}
    end)
  end

  def application_methods do
    Checkout.PriceRule.application_methods()
    |> Enum.map(&({String.capitalize(&1), &1}))
  end
end
