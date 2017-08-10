defmodule Checkout.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      use Checkout.Shared

      import Ecto.Changeset
      import Ecto.Query, only: [from: 2]

      def new(attrs \\ []) do
        struct(__MODULE__, attrs)
      end

      def find(id) do
        Checkout.Repo.get(__MODULE__, id)
      end

      def find!(id) do
        Checkout.Repo.get!(__MODULE__, id)
      end

      def find_by(attrs) do
        Checkout.Repo.get_by(__MODULE__, attrs)
      end

      def find_by!(attrs) do
        Checkout.Repo.get_by!(__MODULE__, attrs)
      end

      def all do
        Checkout.Repo.all(__MODULE__)
      end

      defoverridable [
        new: 1,
        new: 0,
        find: 1,
        find!: 1,
        find_by: 1,
        find_by!: 1,
        all: 0,
      ]
    end
  end
end
