defmodule Web.LayoutView do
  use Web, :view

  def message_levels, do: [
    normal: "dark",
    info: "info",
    warn: "warning",
    error: "danger",
    success: "success",
    announce: "primary",
    debug: "default",
  ]
end
