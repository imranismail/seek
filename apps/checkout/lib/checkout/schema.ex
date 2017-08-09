defmodule Checkout.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      alias Checkout.{
        Repo,
        Customer,
        Product,
        PriceRule,
        CustomerPriceRule,
        ProductPriceRule
      }

      def new(attrs \\ []) do
        struct(__MODULE__, attrs)
      end
    end
  end
end
