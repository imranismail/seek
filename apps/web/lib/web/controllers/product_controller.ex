defmodule Web.ProductController do
  use Web, :controller

  def index(conn, _params) do
    render(conn, products: Product.all())
  end
end
