defmodule Checkout.Shared do
  defmacro __using__(_) do
    quote do
      alias Checkout.{
        Repo,
        Customer,
        Product,
        PriceRule,
        CustomerPriceRule,
        ProductPriceRule
      }
    end
  end
end
