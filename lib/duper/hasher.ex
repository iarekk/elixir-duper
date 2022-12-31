defmodule Duper.Hasher do
  def hash_of_file_at(path) do
    File.stream!(path, [], 1024_1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn block, hash ->
        :crypto.hash_update(hash, block)
      end
    )
    |> :crypto.hash_final()
  end
end
