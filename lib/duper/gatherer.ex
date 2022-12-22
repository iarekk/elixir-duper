defmodule Duper.Gatherer do
  use GenServer
  @me Gatherer

  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def done() do
    GenServer.cast(@me, :done)
  end

  def result(path, hash) do
    GenServer.cast(@me, {:result, path, hash})
  end

  # server
  def init(worker_count) do
    # sends a message to itself to initialize the workers
    # by that time, the Gatherer process will be up and running
    Process.send_after(self(), :kickoff, 0)
    {:ok, worker_count}
  end

  def handle_info(:kickoff, worker_count) do
    IO.puts("Starting the work with #{worker_count} workers")

    1..worker_count
    |> Enum.each(fn _ -> Duper.WorkerSupervisor.add_worker() end)

    {:noreply, worker_count}
  end

  def handle_cast(:done, _worker_count = 1) do
    report_results()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    {:noreply, worker_count - 1}
  end

  def handle_cast({:result, path, hash}, worker_count) do
    Duper.Results.add_hash(path, hash)
    {:noreply, worker_count}
  end

  def report_results() do
    IO.puts("results:\n")

    Duper.Results.find_dupicates()
    |> Enum.each(&IO.inspect/1)
  end
end
