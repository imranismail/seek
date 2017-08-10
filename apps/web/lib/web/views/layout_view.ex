defmodule Web.LayoutView do
  use Web, :view

  def message_levels, do: [
    normal: "primary",
    info: "info",
    warn: "warning",
    error: "danger",
    success: "success",
    debug: "default",
  ]
end
