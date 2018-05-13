ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(UsersService.Repo, :manual)

defmodule UsersService.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias UsersService.Repo

      import Ecto
      import Ecto.Query
      import UsersService.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(UsersService.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(UsersService.Repo, {:shared, self()})
    end

    :ok
  end
end
