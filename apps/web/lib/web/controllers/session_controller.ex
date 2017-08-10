defmodule Web.SessionController do
  use Web, :controller

  plug :scrub_params, "customer" when action == :create

  def new(conn, _params) do
    conn
    |> render("new.html", customers: Customer.all())
  end

  def create(conn, %{"customer" => customer_params}) do
    if customer_params["id"] do
      customer = Customer.find!(customer_params["id"])

      conn
      |> put_session(:session_id, Customer.to_session_id(customer))
      |> redirect(to: product_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Please select an account")
      |> redirect(to: session_path(conn, :new))
    end
  end
end
