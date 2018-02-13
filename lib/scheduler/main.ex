defmodule Scheduler.Main do
  def run(n) do
    inputs = List.duplicate(37, 20)
    1..n
    |> Enum.map(fn(x) ->
      {time, result} = :timer.tc(Scheduler.Scheduler, :run, [x, Scheduler.Fib, :run, inputs])
      {x, {time, result}}
    end)
    |> Enum.each(fn ({num_process, {time, result}}) ->
      if num_process == 1 do
        IO.puts inspect result
      end
      :io.format("~2B    ~.2f~n", [num_process, time/1000000.0])
    end)
  end

  def run_word_count(no) do
    file_paths = File.ls!("./") |> Enum.take_while(fn(x) -> not File.dir?(x) end)
    IO.inspect file_paths
    1..no
    |> IO.inspect
    |> Enum.map(fn(x) ->
      :timer.tc(Scheduler.Scheduler, :run, [x, Scheduler.WordCount, :run, file_paths])
    end)
    |> IO.inspect
    |> Enum.map(fn({time, {file_path, word}}) ->
      :io.format("~.2f ~s ~B", [time/1000000.0, file_path, word])
    end)
  end
end
