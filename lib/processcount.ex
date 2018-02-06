defmodule Processcount do
  @moduledoc """
  Documentation for Processcount.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Processcount.hello
      :world

  """
  def counter(pid) do
    receive do
      n -> 
        send pid, n + 1
        Processcount.counter(pid)
    end    
  end

  def create_processes(n) do
    last = Enum.reduce 1..n, self(), fn(_, send_to) -> spawn(Processcount, :counter, [send_to]) end
    send last, 0
    
    receive do
      n when is_integer(n) ->
        IO.puts "Result is #{n}"
      o -> 
        IO.puts("received something else #{o}")
    end
    
  end

  def run(n) do
    IO.puts inspect :timer.tc(Processcount, :create_processes, [n])
  end

  def mirror_msg(pid) do
    receive do
       msg -> 
        send pid, msg
    end
  end

  def receiver do
    receive do
      msg ->
        IO.puts("I received #{msg}")
        Processcount.receiver
      after 1000 ->
        IO.puts("i quit")
    end
  end

  def ex2() do
    Enum.each 1..100, fn(n) -> 
      pid = spawn(Processcount, :mirror_msg, [self()])
      send pid, "sending #{n}"
    end

    Processcount.receiver
  end
end
