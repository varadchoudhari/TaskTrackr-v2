defmodule TasktrackerWeb.SessionController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User

  def create(conn, %{"name" => name}) do
    user = Accounts.get_user_by_name(name)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back, #{user.name}")
      |> redirect(to: "/feed")
    else
      conn
      |> put_flash(:error, "Invalid Username, please re-login or register if not already a user")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
