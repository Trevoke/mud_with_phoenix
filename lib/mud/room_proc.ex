defmodule Mud.RoomProc do
  use GenServer

  def start_link(%{id: id} = args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, args)
    :ets.insert(:rooms, {id, pid})
    {:ok, pid}
  end
end
