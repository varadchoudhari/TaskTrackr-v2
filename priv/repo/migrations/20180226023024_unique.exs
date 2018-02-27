defmodule Tasktracker.Repo.Migrations.Unique do
  use Ecto.Migration

  def change do
    drop index(:manages, [:managee_id])
    create unique_index(:manages, [:managee_id])
  end
end
