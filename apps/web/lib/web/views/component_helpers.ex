defmodule Web.ComponentHelpers do
  import Phoenix.HTML.Tag, only: [content_tag: 3]

  def component(name, props \\ %{})
  def component(name, props) when is_list(props),
    do: component(name, Enum.into(props, %{}))
  def component(name, props),
    do: content_tag(:div, "", data: [component: name,
                                     props: Poison.encode!(props)])
end
