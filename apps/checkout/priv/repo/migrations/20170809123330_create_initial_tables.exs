defmodule Checkout.Repo.Migrations.CreateInitialTables do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :slug, :string
      add :name, :string

      timestamps()
    end

    create table(:products) do
      add :sku, :string
      add :name, :string
      add :description, :string
      add :price, :integer

      timestamps()
    end

    create unique_index(:products, :sku)

    create table(:price_rules) do
      add :name, :string
      add :value, :integer
      add :usage_limit, :integer
      add :application_method, :string
      add :preq_qty, :integer
      add :preq_qty_operator, :string

      timestamps()
    end

    create table(:customers_price_rules) do
      add :customer_id, references(:customers)
      add :price_rule_id, references(:price_rules)

      timestamps()
    end

    create table(:products_price_rules) do
      add :product_id, references(:products)
      add :price_rule_id, references(:price_rules)

      timestamps()
    end
  end
end
