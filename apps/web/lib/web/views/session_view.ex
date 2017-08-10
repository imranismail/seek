defmodule Web.SessionView do
  use Web, :view

  def customers_to_options(customers) do
    Enum.map(customers, &({&1.name, &1.id}))
  end
end
