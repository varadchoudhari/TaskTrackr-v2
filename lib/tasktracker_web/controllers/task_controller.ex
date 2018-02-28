defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Work
  alias Tasktracker.Work.Task
  alias Tasktracker.Accounts

  def timeblocks(conn, task) do
    timeblocks = Work.get_timeblocks(task, conn.assigns.current_user.id)
    all_blocks = Work.get_allblocks(task, conn.assigns.current_user.id)
    if length(timeblocks) > 0 do
      id = Enum.at(timeblocks, 0).id
    else
      id = nil
    end
    render(conn, "timeblocks.html", taskid: task, timeblocks: timeblocks, id: id, allblocks: all_blocks)
  end

  def index(conn, _params) do
    tasks = Work.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def edittime(conn, block) do
    time = Work.get_time!(block["block"])
    changeset = Work.change_time(time)
    render(conn, "edittime.html", time: time, changeset: changeset)
  end

  def time(conn, params) do
    time = params["time"]
    id = String.to_integer(time["id"])
    start = time["start_time"]
    endt = time["end_time"]
    a = %{"id" => id, "start_time" => start, "end_time" => endt}
    new_time = Work.get_time!(id)
    case Work.update_time(new_time, a) do
      {:ok, new_time} ->
        conn
        |> put_flash(:info, "Time updated successfully.")
        |> redirect(to: page_path(conn, :feed))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edittime.html", time: time, changeset: changeset)
        end
  end

  def deletetime(conn, params, data) do
    IO.inspect params, label: "delete?"
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
