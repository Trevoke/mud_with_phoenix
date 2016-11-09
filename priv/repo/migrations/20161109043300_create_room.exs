defmodule Mud.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :text
      add :exits, :map

      timestamps()
    end

  end
end
