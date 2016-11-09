defmodule Mud.TelnetServer do
  use GenServer
  require Logger

  @doc false
  def start_link(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Mud.TelnetServer.TaskSupervisor]]),
      worker(Task, [Mud.TelnetServer, :accept, [4040]])
    ]

    opts = [strategy: :one_for_one, name: Mud.TelnetServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Mud.TelnetServer.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    foo = socket
    |> read_line()

    write_line("=> #{foo}", socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
