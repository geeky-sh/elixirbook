defmodule Node.Server do
  @interval 2000
  @name :ticket

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(pid) do
    send :global.whereis_name(@name), {:register, pid}
  end

  def generator(clients, count \\ 0) do
    receive do
      {:register, pid} ->
        generator([pid | clients], count + 1)

      after @interval ->
        {client, count} = pick_client(clients, count)
        if client do
          IO.puts("ping from server to client #{inspect client}")
          send client, { :ping }
        end
        generator(clients, count + 1)
    end
  end

  def pick_client(clients, count) when count == 0, do: {nil, 0}
  def pick_client(clients, count) do
    if count > Enum.count(clients) do
      {Enum.at(clients, 0), 0}
    else
      {Enum.at(clients, count), count}
    end
  end
end
