defmodule Web.HealthController do
  use Web, :controller

  def show(conn, _) do
    send_resp(conn, :ok, "200")
  end
end
