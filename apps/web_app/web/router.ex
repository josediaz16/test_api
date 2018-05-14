defmodule WebApp.Router do
  use WebApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", WebApp do
    pipe_through :api

    resources "/users", Api.UserController, only: [:create], as: "api_user"
  end
end
