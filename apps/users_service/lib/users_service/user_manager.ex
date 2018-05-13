defmodule UsersService.UserManager do
  def create(params) do
    changeset = UsersService.User.changeset(%UsersService.User{}, params)
    case UsersService.Repo.insert(changeset) do
      {:ok, user} ->
        %{success: true, user: user}
      {:error, changeset} ->
        %{success: false, errors: parse_errors(changeset)}
    end
  end

  # NOTE: This function could be used to parse any Ecto
  # Changeset in order to return the same error structure
  # every time.
  defp parse_errors(changeset) do
    Enum.reduce(changeset.errors, [], fn {key, value}, list ->
      [
        %{
          object: changeset.data.__struct__,
          field: key,
          error_code: elem(value, 1)[:validation],
          value: changeset.params[to_string(key)],
          description: elem(value, 0)
        }
        | list
      ]
    end)
  end
end
