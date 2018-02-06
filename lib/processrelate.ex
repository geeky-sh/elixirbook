defmodule Processrelate do
  import :timer, only: [sleep: 1]
  def link_process(pid) do
    send pid, "some random thing"
    raise "kick up"
  end

  def receiver do
    receive do
      msg ->
        IO.puts inspect msg
        Processrelate.receiver
      after 1000 ->
        "Fuck you!"
    end
  end
  
  def run do
    res = spawn_monitor(Processrelate, :link_process, [self()])
    IO.puts inspect res

    sleep(500)
 
    Processrelate.receiver

    IO.puts("I am at the last line")
  end
end