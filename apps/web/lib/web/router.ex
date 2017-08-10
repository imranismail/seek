defmodule Web.Router do
  use Web, :router

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

  pipeline :authenticated do
    plug :fetch_customer, redirect_to: "/"
  end

  scope "/", Web do
    pipe_through :browser # Use the default browser stack

    get "/", SessionController, :new
    resources "/session", SessionController, singleton: true, only: [:new, :create]

    pipe_through :authenticated

  end

  # Other scopes may use custom stacks.
  # scope "/api", Web do
  #   pipe_through :api
  # end
end
