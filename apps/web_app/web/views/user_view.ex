defmodule WebApp.UserView do
  use WebApp.Web, :view

  def error_span(errors, field) when is_list(errors) and is_atom(field) do
    error_item = errors
    |> Enum.filter(fn error -> error["field"] == to_string(field) end)
    |> List.first

    case error_item do
      %{"description" => description} ->
        content_tag :span, (humanize(field) <> " " <> description), class: "alert-danger"
      _ ->
        html_escape("")
    end
  end
end
