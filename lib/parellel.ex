defmodule Parellel do
  def pmap(collection, func) do
    me = self()
    collection
    |> Enum.map(fn(x) -> spawn_link(fn -> send me, {self(), func.(x)} end) end)
    |> Enum.map(fn(pid) ->
      receive do
        {pid, result} -> result
      end
    end)
  end
end
