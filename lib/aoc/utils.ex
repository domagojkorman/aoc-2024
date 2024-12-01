defmodule Aoc.Utils do
  def read_file(file) do
    File.read!(Path.join("inputs", file))
  end

  def stream_file(file) do
    File.stream!(Path.join("inputs", file))
    |> Stream.map(fn l -> String.replace_suffix(l, "\n", "") end)
  end
end
