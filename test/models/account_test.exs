defmodule Mud.AccountTest do
  use Mud.ModelCase

  alias Mud.Account

  @valid_attrs %{last_room: 42, password: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
