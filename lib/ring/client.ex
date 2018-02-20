defmodule Ring.Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Node.Server.register(pid)
  end

  def receiver do
    receive do
      {:ping} ->
        IO.puts "pong in client #{inspect self()}"
        receiver()
    end
  end
end
