defmodule Duper.Worker do
  use GenServer, restart: :transient

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def init(:no_args) do
    Process.send_after(self(), :do_one_file, 0)
    {:ok, nil}
  end

  def handle_info(:do_one_file, _) do
    Duper.Pathfinder.next_path()
    |> add_result()
  end

  def add_result(nil) do
    Duper.Gatherer.done()
    {:stop, :normal, nil}
  end

  def add_result(path) do
    Duper.Gatherer.result(path, hasher().hash_of_file_at(path))
    send(self(), :do_one_file)
    {:noreply, nil}
  end

  def hasher() do
    Application.get_env(:duper, :hasher)
  end
end
