defmodule DirWalkerMock do
  use GenServer
  @me __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, ["a1.txt", "a2.txt", "a1.xls"], name: @me)
  end

  def init(list) do
    {:ok, list}
  end

  def next(server) do
    GenServer.call(server, {:next_path})
  end

  def handle_call({:next_path}, _from, path_list) do
    {next_path, new_list} =
      case path_list do
        [p | tail] -> {p, tail}
        [] -> {nil, []}
      end

    {:reply, next_path, new_list}
  end
end
