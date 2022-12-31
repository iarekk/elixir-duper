defmodule Duper.ResultsTest do
  use ExUnit.Case
  alias Duper.Results

  setup do
    child_spec = %{
      id: Results,
      start: {Results, :start_link, [[], [name: :test]]}
    }

    pid = start_supervised!(child_spec)
    {:ok, sut: pid}
  end

  test "can add entries to the results", state do
    pid = state[:sut]
    GenServer.cast(pid, {:hash_add, "path1", 123})
    GenServer.cast(pid, {:hash_add, "path2", 456})
    GenServer.cast(pid, {:hash_add, "path3", 123})
    GenServer.cast(pid, {:hash_add, "path4", 789})
    GenServer.cast(pid, {:hash_add, "path5", 789})

    duplicates = GenServer.call(pid, :find_duplicates)
    assert length(duplicates) == 2
    assert ~w(path3 path1) in duplicates
    assert ~w(path5 path4) in duplicates
  end
end
