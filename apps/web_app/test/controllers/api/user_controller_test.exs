defmodule WebApp.Api.UserControllerTest do
  use WebApp.ConnCase
  use WebApp.RepoCase

  test "Creates a new user when the data is valid", %{conn: conn} do
    data = %{
      user: %{
        email: "joey@friends.com",
        name: "Joey",
        phone_number: "123456",
        password: "123456",
        password_confirmation: "123456",
        country: "Colombia"
      }
    }

    response =
      conn
      |>  post(api_user_path(conn, :create), data)
      |> json_response(201)

    expected = %{
      "address" => nil,
      "city" => nil,
      "country" => "Colombia",
      "email" => "joey@friends.com",
      "name" => "Joey",
      "phone_number" => "123456"
    }

    assert expected == Map.delete(response, "id")

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 1
  end

  test "Respond 400 with errors when data is missing", %{conn: conn} do
    data = %{
      user: %{
        phone_number: "123456",
        password: "123456",
        password_confirmation: "123456",
        country: "Colombia"
      }
    }

    response =
      conn
      |>  post(api_user_path(conn, :create), data)
      |> json_response(400)

    expected = %{
      "errors" => [
        %{
          "description" => "can't be blank",
          "error_code" => "required",
          "field" => "email",
          "object" => "Elixir.UsersService.User",
          "value" => nil
        },
        %{
          "description" => "can't be blank",
          "error_code" => "required",
          "field" => "name",
          "object" => "Elixir.UsersService.User",
          "value" => nil
        }
      ]
    }

    assert response == expected

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 0
  end

  test "Respond 400 with errors when passwords don't match", %{conn: conn} do
    data = %{
      user: %{
        email: "joey@friends.com",
        name: "Joey",
        phone_number: "123456",
        password: "123456",
        password_confirmation: "12345",
        country: "Colombia"
      }
    }

    response =
      conn
      |>  post(api_user_path(conn, :create), data)
      |> json_response(400)

    expected = %{
      "errors" => [
        %{
          "description" => "does not match confirmation",
          "error_code" => "confirmation",
          "field" => "password_confirmation",
          "object" => "Elixir.UsersService.User",
          "value" => "12345"
        }
      ]
    }

    assert response == expected

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 0
  end

  test "Respond 400 with errors when email does not have @", %{conn: conn} do
    data = %{
      user: %{
        email: "joey.friends.com",
        name: "Joey",
        phone_number: "123456",
        password: "123456",
        password_confirmation: "123456",
        country: "Colombia"
      }
    }

    response =
      conn
      |>  post(api_user_path(conn, :create), data)
      |> json_response(400)

    expected = %{
      "errors" => [
        %{
          "description" => "has invalid format",
          "error_code" => "format",
          "field" => "email",
          "object" => "Elixir.UsersService.User",
          "value" => "joey.friends.com"
        }
      ]
    }

    assert response == expected

    assert UsersService.User |> UsersService.Repo.aggregate(:count, :id) == 0
  end
end
