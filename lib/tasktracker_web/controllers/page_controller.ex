defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Work

  def index(conn, _params) do
    if get_session(conn, :user_id) != nil do
      feed(conn, nil)
    else
      render conn, "index.html"
    end
  end

  def feed(conn, _params) do
    tasks =  Work.list_tasks()
    render conn, "feed.html", tasks: tasks
  end

  def your(conn, _params) do
    tasks = Work.list_tasks()
    render conn, "your.html", tasks: tasks
  end

  def created(conn, _params) do
    tasks = Work.list_tasks()
    render conn, "created.html", tasks: tasks
  end

  def report(conn, _params) do
    report = Work.my_tasks(conn.assigns.current_user.id)
    render(conn, "report.html", report: report)
  end
end
