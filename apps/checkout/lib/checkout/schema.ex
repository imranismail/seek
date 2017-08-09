defmodule Checkout.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      use Checkout.Shared

      def new(attrs \\ []) do
        struct(__MODULE__, attrs)
      end

      def find!(id) do
        Checkout.Repo.get!(__MODULE__, id)
      end

      def find_by!(attrs) do
        Checkout.Repo.get_by!(__MODULE__, attrs)
      end

      def all do
        Checkout.Repo.all(__MODULE__)
      end
    end
  end
end
