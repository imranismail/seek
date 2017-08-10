defmodule Web.CartController do
  use Web, :controller

  def add_item(conn, params) do
    customer = conn.assigns.current_session
    product = Product.find!(params["product_id"])

    Customer.add_item(customer, product)

    conn
    |> put_flash(:success, "Added #{product.name} to cart")
    |> redirect(to: product_path(conn, :index))
  end

  def show(conn, _params) do
    customer = conn.assigns.current_session
    checkout = Customer.checkout(customer)

    render(conn, checkout: checkout)
  end

  def delete(conn, _params) do
    customer = conn.assigns.current_session

    Customer.clear_cart(customer)

    redirect(conn, to: product_path(conn, :index))
  end
end
