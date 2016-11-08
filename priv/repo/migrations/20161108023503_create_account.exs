defmodule Mud.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :username, :string
      add :password, :string
      add :last_room, :integer

      timestamps()
    end

  end
end
