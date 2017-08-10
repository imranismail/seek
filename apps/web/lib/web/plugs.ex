defmodule Web.Plug do
  use Web, :plug

  def fetch_customer(conn, opts) do
    conn
    |> get_session(:session_id)
    |> Customer.from_session_id()
    |> case do
      nil ->
        redirect(conn, to: Keyword.fetch!(opts, :redirect_to))
      customer ->
        assign(conn, :current_session, Customer.load_cart(customer))
    end
  end
end
