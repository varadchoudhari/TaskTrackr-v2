defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User
  alias Tasktracker.Work

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    users = Accounts.list_users()
    manages = Tasktracker.Work.manages_map_for(current_user.id)
    render(conn, "index.html", users: users, manages: manages)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully, you may now login")
        |> redirect(to: page_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
        end
      end

      def show(conn, %{"id" => id}) do
        user = Accounts.get_user!(id)
        render(conn, "show.html", user: user)
      end

      def edit(conn, %{"id" => id}) do
        user = Accounts.get_user!(id)
        changeset = Accounts.change_user(user)
        render(conn, "edit.html", user: user, changeset: changeset)
      end

      def update(conn, %{"id" => id, "user" => user_params}) do
        user = Accounts.get_user!(id)

        case Accounts.update_user(user, user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: user_path(conn, :show, user))
            {:error, %Ecto.Changeset{} = changeset} ->
              render(conn, "edit.html", user: user, changeset: changeset)
            end
          end

          def delete(conn, %{"id" => id}) do
            user = Accounts.get_user!(id)
            {:ok, _user} = Accounts.delete_user(user)

            conn
            |> put_flash(:info, "User deleted successfully.")
            |> redirect(to: user_path(conn, :index))
          end

          def profile(conn, _params) do
            user = Accounts.get_user!(conn.assigns.current_user.id)
            managees = Work.get_manages(conn.assigns.current_user.id)
            manager = Work.get_manager(conn.assigns.current_user.id)
            render(conn, "profile.html", user: user, managees: managees, managers: manager)
          end
        end
