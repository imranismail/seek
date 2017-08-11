defmodule Checkout.Schema do
  import Ecto.Query, only: [dynamic: 2, from: 2]
  import Ecto.Changeset

  alias Checkout.Repo

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      use Checkout.Shared

      import unquote(__MODULE__)
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

  def put_assoc_by(changeset, field, filters) do
    case changeset.types[field] do
      {:assoc, assoc} ->
        dynamic = Enum.reduce(
          filters,
          false,
          &(dynamic_assoc(&2, &1, changeset.params))
        )
        query = from q in assoc.queryable, where: ^dynamic
        put_assoc(changeset, field, Repo.all(query))
      _ ->
        changeset
    end
  end

  defp dynamic_assoc(dynamic, {:includes, attrs}, params) do
    Enum.reduce(attrs, dynamic, fn {field, attr}, dynamic ->
      if includes = Map.get(params, attr) do
        dynamic([q], field(q, ^field) in ^includes)
      else
        dynamic
      end
    end)
  end

  defp dynamic_assoc(dynamic, {:excludes, attrs}, params) do
    Enum.reduce(attrs, dynamic, fn {field, attr}, dynamic ->
      if excludes = Map.get(params, attr) do
        dynamic([q], field(q, ^field) not in ^excludes)
      else
        dynamic
      end
    end)
  end
end
