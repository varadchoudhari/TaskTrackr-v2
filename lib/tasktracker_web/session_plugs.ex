defmodule SessionPlugs do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Tasktracker.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end
end
