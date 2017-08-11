defmodule Checkout.Product do
  use Checkout.Schema

  schema "products" do
    field :sku, :string
    field :name, :string
    field :description, :string
    field :price, :integer

    many_to_many :price_rules, PriceRule, join_through: ProductPriceRule

    timestamps()
  end

  @permitted ~w(id sku name description price)a

  def changeset(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, @permitted)
  end

  def search(query) do
    from q in __MODULE__, where: ilike(q.name , ^"%#{query}%")
  end

  def exclude(queryable, ids) when is_list(ids) do
    from q in queryable, where: q.id not in ^ids
  end

  def select(queryable, schema \\ :default)
  def select(queryable, schema) when schema in [:default, "default"] do
    Repo.all(queryable)
  end
  def select(queryable, schema) when schema in [:option, "option"] do
    Repo.all(from q in queryable, select: %{label: q.name, value: q.id})
  end
end
