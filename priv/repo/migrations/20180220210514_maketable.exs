defmodule Tasktracker.Repo.Migrations.Maketable do
  use Ecto.Migration

  def change do
	create table(:users) do
		add :name, :string, null: false
		timestamps()
	end
	create unique_index(:users, [:name])
	create table(:tasks) do
		add :title, :text, null: false
		add :body, :text, null: false
		add :completed, :boolean, default: false, null: false
		add :user_id, references(:users, on_delete: :delete_all), null: false
		add :assigned_id, references(:users, on_delete: :nothing)
		add :time_taken, :integer
		timestamps()
	end
	create index(:tasks, [:user_id, :assigned_id])
  end
end
