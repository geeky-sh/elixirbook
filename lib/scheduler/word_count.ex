defmodule Scheduler.WordCount do
  def run(scheduler) do
    send scheduler, {:ready, self()}
    receive do
      { :fib, n, client } ->
        send client, {:answer, n, calc(n)}
        Scheduler.WordCount.run(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  def calc(file_path) do
    IO.inspect(file_path)
    {:ok, content} = File.read!(file_path)

    count = Enum.count(
      String.split(content, ~r{\s}),
      fn(x) -> x == "cat" end
    )
    {file_path, count}
  end
end
