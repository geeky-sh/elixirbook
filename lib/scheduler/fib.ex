defmodule Scheduler.Fib do
  def run(scheduler) do
    send scheduler, {:ready, self()}
    receive do
      { :fib, n, client } ->
        send client, {:answer, n, fib_calc(n)}
        Scheduler.Fib.run(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  def fib_calc(0), do: 0
  def fib_calc(1), do: 1
  def fib_calc(n), do: Scheduler.Fib.fib_calc(n - 1) + Scheduler.Fib.fib_calc(n - 2)
end
