defmodule Tasktracker.Work.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Work.Task


  schema "tasks" do
    field :body, :string, null: false
    field :completed, :boolean, default: false
    field :title, :string, null: false
    belongs_to :user, Tasktracker.Accounts.User, foreign_key: :user_id
    belongs_to :assigned, Tasktracker.Accounts.User, foreign_key: :assigned_id
    field :time_taken, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :body, :completed, :user_id, :assigned_id, :time_taken])
    |> validate_required([:title, :body, :completed, :user_id, :assigned_id, :time_taken])
    |> validate_change(:time_taken, fn :time_taken, time ->
      if rem(time, 15) != 0 do
        [time_taken: "Invalid time, please enter in the multiples of 15"]
      else
        []
      end
    end
    )
  end
end
