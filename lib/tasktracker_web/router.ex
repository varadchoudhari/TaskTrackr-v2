defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug SessionPlugs
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TasktrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/feed", PageController, :feed
    get "/your", PageController, :your
    get "/created", PageController, :created
    get "/report", PageController, :report
    get "/profile", UserController, :profile
    get "/timeblocks", TaskController, :timeblocks
    get "/edittime", TaskController, :edittime
    resources "/users", UserController
    resources "/tasks", TaskController

    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", TasktrackerWeb do
    pipe_through :api
    resources "/manages", ManageController, except: [:new, :edit]
    resources "/timeblocks", TimeController, except: [:new, :edit]
  end
end
