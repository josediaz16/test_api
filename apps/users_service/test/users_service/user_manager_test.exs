defmodule UsersService.UserManagerTest do
  alias UsersService.User
  alias UsersService.Repo

  use ExUnit.Case
  use UsersService.RepoCase

  test "User is persisted if data is valid" do
    params = %{name: "Joey", password: "123456", password_confirmation: "123456", phone_number: "333445566", email: "joey@friends.com"}
    response = UsersService.UserManager.create(params)
    user = response[:user]

    assert response[:success]
    assert Comeonin.Bcrypt.checkpw("123456", user.password_hash)
    assert User |> Repo.aggregate(:count, :id) == 1
  end

  test "User is not persisted if data is not valid" do
    params = %{name: "Joey", password: "123456", password_confirmation: "12345", email: "joey@friends.com"}
    response = UsersService.UserManager.create(params)
    errors = response[:errors]

    refute response[:success]
    assert User |> Repo.aggregate(:count, :id) == 0

    assert errors == [
      %{
        description: "can't be blank",
        error_code: :required,
        field: :phone_number,
        object: UsersService.User,
        value: nil
      },
      %{
        description: "does not match confirmation",
        error_code: :confirmation,
        field: :password_confirmation,
        object: UsersService.User,
        value: "12345"
      }
    ]
  end
end
