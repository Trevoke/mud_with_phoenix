defmodule Mud.Rooms do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    :ets.new(:rooms, [:named_table, {:read_concurrency, true}])
    children = [
      worker(Mud.Room,
        [
          %{description: "Room 1",
            id: 1,
            exits: %{"w" => 2}},
        ],
        restart: :permanent,
        id: 1),
      worker(Mud.Room,
        [
          %{description: "Room 2",
            id: 2,
            exits: %{"e" => 1}},
        ],
        restart: :permanent,
        id: 2),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
