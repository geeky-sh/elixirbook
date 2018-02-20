defmodule Ring.Main do
  def start_client(pid) do
    receive do
      {sender, count} ->
        IO.puts("Received from #{inspect sender} value #{count}")
        :timer.sleep(1000)
        send pid, {self(), count + 1}
        start_client(pid)
    end
  end
  def init(num) do
    last = Enum.reduce 1..num, self(), fn(_, pid) ->
      spawn(Ring.Main, :start_client, [pid])
    end
    send last, {self(), 0}

    start_client(last)
  end
end
