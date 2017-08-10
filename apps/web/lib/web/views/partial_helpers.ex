defmodule Web.PartialHelpers do
  alias Web.PartialView

  def partial(template) do
    PartialView.render(template, [])
  end

  def partial(template, do: block) do
    PartialView.render(template, do: block)
  end

  def partial(template, assigns) do
    PartialView.render(template, assigns)
  end

  def partial(template, assigns, do: block) do
    PartialView.render(template, Keyword.merge(assigns, [do: block]))
  end
end
