defmodule Stack do
  use GenServer

  def start_link(list) do
    GenServer.start_link __MODULE__, list, [name: __MODULE__, debug: [:statistics, :trace]]
  end

  def push(n) do
    GenServer.cast(__MODULE__, {:push, n})
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def get_stats do
    :sys.get_status __MODULE__
  end

  def remove_trace do
    :sys.trace __MODULE__, false
  end

  def add_trace(), do: :sys.trace(__MODULE__, true)

  def remove_stats, do: :sys.statistics(__MODULE__, false)
  def aed_stats, do: :sys.statistics(__MODULE__, true)

  def kill_me(), do: Process.whereis(__MODULE__) |> Process.exit

  def handle_call(:pop, _from, [head | tail]), do: {:reply, head, tail}

  def handle_cast({:push, n}, list), do: {:noreply, [n | list]}
end

"""
{:ok, pid} = GenServer.start_link(Queue, [5, 'aash', 8, 9])
GenServer.call(pid, :pop)
GenServer.cast(pid, {:push, 10})

"""
