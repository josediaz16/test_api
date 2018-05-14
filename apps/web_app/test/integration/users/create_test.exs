defmodule WebApp.Integration.Users.Create do
  use WebApp.IntegrationCase
  use WebApp.RepoCase

  test "Creates a new user when the data is valid", %{conn: conn} do
    get(conn, user_path(conn, :new))
    |> follow_form( %{user:
        %{
          email: "joey@friends.com",
          name: "Joey",
          phone_number: "123456",
          password: "123456",
          password_confirmation: "123456",
          country: "Colombia"
        }
      })
    |> assert_response(
      status: 200,
      path: page_path(conn, :index),
      html: "The user was created successfully"
    )

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 1
  end

  test "Render form again with errors when data is missing", %{conn: conn} do
    get(conn, user_path(conn, :new))
    |> follow_form( %{user:
        %{
          phone_number: "123456",
          password: "123456",
          password_confirmation: "123456",
          country: "Colombia"
        }
      })
    |> assert_response(
      status: 200,
      path: user_path(conn, :create),
      html: "Email can&#39;t be blank",
      html: "Name can&#39;t be blank"
    )

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 0
  end

  test "Render form again with errors when passwords don't match", %{conn: conn} do
    get(conn, user_path(conn, :new))
    |> follow_form( %{user:
        %{
          email: "joey@friends.com",
          name: "Joey",
          phone_number: "123456",
          password: "123456",
          password_confirmation: "12345",
          country: "Colombia"
        }
      })
    |> assert_response(
      status: 200,
      path: user_path(conn, :create),
      html: "Password confirmation does not match confirmation"
    )

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 0
  end

  test "Render form again with errors when email does not have @", %{conn: conn} do
    get(conn, user_path(conn, :new))
    |> follow_form( %{user:
        %{
          email: "joey.friends.com",
          name: "Joey",
          phone_number: "123456780",
          password: "123456",
          password_confirmation: "123456",
          country: "Colombia"
        }
      })
    |> assert_response(
      status: 200,
      path: user_path(conn, :create),
      html: "Email has invalid format"
    )

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 0
  end
end
