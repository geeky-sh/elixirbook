defmodule Scheduler.Scheduler do
  def run(processes, module, func, to_calculate) do
    (1..processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  def schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [head | tail] = queue
        send pid, {:fib, head, self()}
        schedule_processes(processes, tail, results)
      {:ready, pid} when length(processes) > 1 ->
        send pid, {:shutdown}
        schedule_processes(List.delete(processes, pid), queue, results)
      {:ready, pid} ->
        send pid, {:shutdown}
        Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
      {:answer, n, answer} ->
        schedule_processes(processes, queue, [{n, answer} | results])
    end
  end
end
