defmodule HasherMock do
  def hash_of_file_at(path) do
    split = String.split(path, ".")

    case split do
      [name, _ext] -> "hash #{name}"
      _ -> nil
    end
  end
end
