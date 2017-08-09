defmodule Checkout do
  @moduledoc """
  Checkout keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmacro __using__(which) do
    apply(__MODULE__, which, [])
  end

  def schema do
    quote do
      use Ecto.Schema

      def new(attrs \\ []) do
        struct(__MODULE__, attrs)
      end
    end
  end

  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end
end
