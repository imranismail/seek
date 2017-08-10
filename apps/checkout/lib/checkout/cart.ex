defmodule Checkout.Cart do
  use Checkout.Shared

  defstruct [:customer_id, items: []]

  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end

  def find_or_create(id) when is_integer(id) do
    {_status, cart} =
      Cachex.get(__MODULE__, id, fallback: &new(customer_id: &1))
    cart
  end

  def update(id, cart) when is_integer(id) do
    Cachex.update(__MODULE__, id, cart)
  end

  def delete(id) when is_integer(id) do
    Cachex.del(__MODULE__, id)
  end
end
