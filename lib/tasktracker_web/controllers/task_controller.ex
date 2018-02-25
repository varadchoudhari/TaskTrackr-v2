defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Work
  alias Tasktracker.Work.Task
  alias Tasktracker.Accounts

  def index(conn, _params) do
    tasks = Work.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Work.change_task(%Task{})
    # old users
    #users = Accounts.list_users()
    # new users, where only users that the current user manages are visible
    users = Work.get_manages(conn.assigns.current_user.id)
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"task" => task_params}) do
    new_params = Map.put(task_params, "user_id", conn.assigns.current_user.id)
    #users = Accounts.list_users()
    users = Work.get_manages(conn.assigns.current_user.id)
    case Work.create_task(new_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: page_path(conn, :feed))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, users: users)
        end
      end

      def show(conn, %{"id" => id}) do
        task = Work.get_task!(id)
        render(conn, "show.html", task: task)
      end

      def edit(conn, %{"id" => id}) do
        task = Work.get_task!(id)
        changeset = Work.change_task(task)
        users = Accounts.list_users()
        render(conn, "edit.html", task: task, changeset: changeset, users: users)
      end

      def update(conn, %{"id" => id, "task" => task_params}) do
        task = Work.get_task!(id)
        users = Accounts.list_users()
        case Work.update_task(task, task_params) do
          {:ok, task} ->
            conn
            |> put_flash(:info, "Task updated successfully.")
            |> redirect(to: page_path(conn, :feed))
            {:error, %Ecto.Changeset{} = changeset} ->
              render(conn, "edit.html", task: task, changeset: changeset, users: users)
            end
          end

          def delete(conn, %{"id" => id}) do
            task = Work.get_task!(id)
            {:ok, _task} = Work.delete_task(task)

            conn
            |> put_flash(:info, "Task deleted successfully.")
            |> redirect(to: page_path(conn, :feed))
          end
        end
