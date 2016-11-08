defmodule Mud.Account do
  use Mud.Web, :model

  schema "accounts" do
    field :username, :string
    field :password, Comeonin.Ecto.Password
    field :last_room, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password, :last_room])
    |> validate_required([:username, :password, :last_room])
  end
end
