defmodule Duper.Results do
  use GenServer
  @me __MODULE__

  # public API

  def start_link(_, opts \\ []) do
    name = Keyword.get(opts, :name, @me)
    IO.puts("name: #{name}")
    GenServer.start_link(__MODULE__, :no_args, name: name)
  end

  def add_hash(path, hash) do
    GenServer.cast(@me, {:hash_add, path, hash})
  end

  def find_dupicates() do
    GenServer.call(@me, :find_duplicates)
  end

  # GenServer implementation

  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_cast({:hash_add, path, hash}, resultmap) do
    new_result =
      Map.update(
        resultmap,
        hash,
        [path],
        fn existing -> [path | existing] end
      )

    {:noreply, new_result}
  end

  def handle_call(:find_duplicates, _from, resultmap) do
    duplicates =
      resultmap
      |> Enum.filter(fn {_hash, paths} -> length(paths) > 1 end)
      |> Enum.map(fn {_hash, paths} -> paths end)

    {:reply, duplicates, resultmap}
  end
end
