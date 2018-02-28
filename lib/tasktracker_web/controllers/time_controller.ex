defmodule TasktrackerWeb.TimeController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Work
  alias Tasktracker.Work.Time

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    timeblocks = Work.list_timeblocks()
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def create(conn, %{"timeblocks" => time_params}) do
    with {:ok, %Time{} = time} <- Work.create_time(time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", time_path(conn, :show, time))
      |> render("show.json", time: time)
    end
  end

  def show(conn, %{"id" => id}) do
    time = Work.get_time!(id)
    render(conn, "show.json", time: time)
  end

  def update(conn, %{"id" => id, "timeblocks" => time_params}) do
    IO.inspect "is here?"
    time = Work.get_time!(id)

    with {:ok, %Time{} = time} <- Work.update_time(time, time_params) do
      render(conn, "show.json", time: time)
    end
  end

  def delete(conn, %{"id" => id}) do
    time = Work.get_time!(id)
    with {:ok, %Time{}} <- Work.delete_time(time) do
      send_resp(conn, :no_content, "")
    end
  end
end
