defmodule Tasktracker.Work.Time do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Work.Time


  schema "timeblocks" do
    field :end_time, :string
    field :start_time, :string
    belongs_to :task, Tasktracker.Work.Task, foreign_key: :task_id
    belongs_to :user, Tasktracker.Accounts.User, foreign_key: :assigned_id

    timestamps()
  end

  @doc false
  def changeset(%Time{} = time, attrs) do
    time
    |> cast(attrs, [:start_time, :end_time, :task_id, :assigned_id])
    |> validate_required([:start_time, :end_time])
  end
end
