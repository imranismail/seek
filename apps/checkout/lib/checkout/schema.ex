defmodule Checkout.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      use Checkout.Shared

      def new(attrs \\ []) do
        struct(__MODULE__, attrs)
      end
    end
  end
end
