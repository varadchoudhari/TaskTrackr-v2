defmodule Tasktracker.AssignTest do
  use Tasktracker.DataCase

  alias Tasktracker.Assign

  describe "assigns" do
    alias Tasktracker.Assign.Job

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def job_fixture(attrs \\ %{}) do
      {:ok, job} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Assign.create_job()

      job
    end

    test "list_assigns/0 returns all assigns" do
      job = job_fixture()
      assert Assign.list_assigns() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Assign.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      assert {:ok, %Job{} = job} = Assign.create_job(@valid_attrs)
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assign.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      assert {:ok, job} = Assign.update_job(job, @update_attrs)
      assert %Job{} = job
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Assign.update_job(job, @invalid_attrs)
      assert job == Assign.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Assign.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Assign.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Assign.change_job(job)
    end
  end
end
