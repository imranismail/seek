defmodule Checkout.PriceRule do
  use Checkout.Schema

  schema "price_rules" do
    field :name, :string
    field :value, :integer
    field :usage_limit, :integer
    field :application_method, :string
    field :preq_qty, :integer
    field :preq_qty_operator, :string

    many_to_many :entitled_customers, Customer, join_through: CustomerPriceRule
    many_to_many :entitled_products, Product, join_through: ProductPriceRule

    timestamps()
  end

  @permitted ~w(
    name
    value
    usage_limit
    application_method
    preq_qty
    preq_qty_operator
  )a

  @required ~w(
    name
    value
    application_method
  )a

  def changeset(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> validate_preq_qty()
    |> validate_preq_qty_operator()
    |> validate_number(:value, less_than: 0)
    |> validate_number(:usage_limit, greater_than: 0)
    |> validate_inclusion(:preq_qty_operator, comparison_operators())
    |> validate_inclusion(:application_method, application_methods())
  end

  def comparison_operators do
    ~w(
      less_than
      greater_than
      less_than_or_equal_to
      greater_than_or_equal_to
      equal_to
    )
  end

  def application_methods do
    ~w(across each)
  end

  def apply_to(price_rule, checkout) do
    if apply?(price_rule, checkout) do
      do_apply_to(price_rule, checkout)
    else
      checkout
    end
  end

  def preload(price_rules, assocs \\ [:entitled_customers, :entitled_products]) do
    Repo.preload(price_rules, assocs)
  end

  defp validate_preq_qty(changeset) do
    if get_change(changeset, :preq_qty) do
      validate_required(
        changeset,
        :preq_qty_operator,
        message: "required if quantity is set"
      )
    else
      changeset
    end
  end

  defp validate_preq_qty_operator(changeset) do
    if get_change(changeset, :preq_qty_operator) do
      validate_required(
        changeset,
        :preq_qty,
        message: "required if comparison is set"
      )
    else
      changeset
    end
  end

  defp apply?(price_rule, checkout) do
    entitled_customer?(price_rule, checkout)
    and not exceed_usage_limit?(price_rule, checkout)
    and satisfied_preq_qty?(price_rule, checkout)
  end

  defp entitled_customer?(price_rule, checkout) do
    if Enum.empty?(price_rule.entitled_customers) do
      true
    else
      Enum.any?(price_rule.entitled_customers, &(&1.id == checkout.customer.id))
    end
  end

  defp entitled_products?(price_rule, product) do
    if Enum.empty?(price_rule.entitled_products) do
      true
    else
      Enum.any?(price_rule.entitled_products, &(&1.id == product.id))
    end
  end

  defp exceed_usage_limit?(price_rule, checkout) do
    checkout
    |> Map.fetch!(:applied_price_rules)
    |> Enum.filter(&(&1.id == price_rule.id))
    |> Enum.count()
    |> Kernel.>=(price_rule.usage_limit)
  end

  defp satisfied_preq_qty?(price_rule, checkout) do
    count =
      checkout.items
      |> Enum.filter(&entitled_products?(price_rule, &1))
      |> Enum.count()

    case price_rule.preq_qty_operator do
      "less_than"  -> count < price_rule.preq_qty
      "greater_than" -> count > price_rule.preq_qty
      "less_than_or_equal_to" -> count <= price_rule.preq_qty
      "greater_than_or_equal_to" -> count >= price_rule.preq_qty
      "equal_to" -> count == price_rule.preq_qty
      nil -> true
    end
  end

  defp do_apply_to(price_rule, checkout) do
    case price_rule.application_method do
      "across" ->
        %{checkout |
          total: checkout.total + price_rule.value,
          discount: checkout.discount + price_rule.value,
          applied_price_rules: checkout.applied_price_rules ++ [price_rule]
        }
      "each" ->
        checkout.items
        |> Enum.filter(&(&1 in price_rule.entitled_products))
        |> Enum.reduce(checkout, fn _item, checkout ->
          %{checkout |
            total: checkout.total + price_rule.value,
            discount: checkout.discount + price_rule.value,
            applied_price_rules: checkout.applied_price_rules ++ [price_rule]
          }
        end)
    end
  end
end
