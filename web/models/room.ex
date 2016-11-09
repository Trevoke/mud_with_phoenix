defmodule Mud.Room do
  use Mud.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "rooms" do
    field :description, :string
    field :exits, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :exits])
    |> validate_required([:description, :exits])
  end
end
