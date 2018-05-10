defmodule UsersService.UsersTest do
  alias UsersService.User
  use ExUnit.Case

  test "Changeset is valid if all attributes are correct" do
    changeset = User.changeset(
      %User{},
      %{name: "Joey", password: "123456", password_confirmation: "123456", phone_number: "333445566", email: "joey@friends.com"}
    )
    assert changeset.valid?
    assert Comeonin.Bcrypt.checkpw("123456", changeset.changes[:password_hash])
  end

  test "Changeset is invalid if it's empty" do
    changeset = User.changeset(%User{}, %{})
    refute changeset.valid?
  end

  test "Changeset is invalid if email is empty" do
    changeset = User.changeset(
      %User{},
      %{name: "Joey", password: "123456", password_confirmation: "123456", phone_number: "333445566"}
    )

    refute changeset.valid?
    assert length(changeset.errors) == 1
    assert changeset.errors[:email] == {"can't be blank", [validation: :required]}
  end

  test "Changeset is invalid if name is empty" do
    changeset = User.changeset(
      %User{},
      %{password: "123456", password_confirmation: "123456", phone_number: "333445566", email: "joey@friends.com"}
    )

    refute changeset.valid?
    assert length(changeset.errors) == 1
    assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
  end

  test "Changeset is invalid if password is empty" do
    changeset = User.changeset(
      %User{},
      %{phone_number: "333445566", email: "joey@friends.com", name: "joey"}
    )

    refute changeset.valid?
    assert length(changeset.errors) == 1
    assert changeset.errors[:password] == {"can't be blank", [validation: :required]}
  end

  test "Changeset is invalid if phone_number is empty" do
    changeset = User.changeset(
      %User{},
      %{password: "123456", password_confirmation: "123456", email: "joey@friends.com", name: "joey"}
    )

    refute changeset.valid?
    assert length(changeset.errors) == 1
    assert changeset.errors[:phone_number] == {"can't be blank", [validation: :required]}
  end

  test "Changeset is invalid if password is not equal to password confirmation" do
    changeset = User.changeset(
      %User{},
      %{phone_number: "333445566", password: "12345", password_confirmation: "123456", email: "joey@friends.com", name: "joey"}
    )

    refute changeset.valid?
    assert changeset.errors[:password_confirmation] == {"does not match confirmation", [validation: :confirmation]}
  end
end
