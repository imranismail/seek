defmodule Web.SessionController do
  use Web, :controller

  def new(conn, _params) do
    render conn, "new.html", customers: Customer.all
  end
end
