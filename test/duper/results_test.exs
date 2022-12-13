defmodule Duper.ResultsTest do
  use ExUnit.Case
  alias Duper.Results

  test "can add entries to the results" do
    Results.add_hash("path1", 123)
    Results.add_hash("path2", 456)
    Results.add_hash("path3", 123)
    Results.add_hash("path4", 789)
    Results.add_hash("path5", 789)

    duplicates = Results.find_dupicates()
    assert length(duplicates) == 2
    assert ~w(path3 path1) in duplicates
    assert ~w(path5 path4) in duplicates
  end
end
