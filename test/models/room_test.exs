defmodule Mud.RoomTest do
  use Mud.ModelCase

  alias Mud.Room

  @valid_attrs %{description: "some content", exits: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Room.changeset(%Room{}, @invalid_attrs)
    refute changeset.valid?
  end
end
