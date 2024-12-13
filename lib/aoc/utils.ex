defmodule Aoc.Utils do
  def read_file(file) do
    File.read!(Path.join("inputs", file))
    |> String.split("\n\n")
  end

  def stream_file(file) do
    File.stream!(Path.join("inputs", file))
    |> Stream.map(fn l -> String.replace_suffix(l, "\n", "") end)
  end

  def matrix_to_map(matrix) do
    Enum.with_index(matrix)
    |> Enum.reduce(%{}, fn {row, row_index}, map ->
      Enum.reduce(Enum.with_index(row), map, fn {value, col_index}, map ->
        Map.put(map, {row_index, col_index}, value)
      end)
    end)
  end

  def next_coordinates(coord, diagonal \\ false) do
    neighbors = [:up, :left, :down, :right] |> Enum.map(&next_coordinate(coord, &1))

    diagonal_neighbors =
      [:up_left, :up_right, :down_left, :down_right] |> Enum.map(&next_coordinate(coord, &1))

    if diagonal, do: neighbors ++ diagonal_neighbors, else: neighbors
  end

  def next_coordinate({row, col}, direction) do
    case direction do
      :up -> {row - 1, col}
      :left -> {row, col - 1}
      :down -> {row + 1, col}
      :right -> {row, col + 1}
      :up_left -> {row - 1, col - 1}
      :up_right -> {row - 1, col + 1}
      :down_left -> {row + 1, col - 1}
      :down_right -> {row + 1, col + 1}
    end
  end

  def regex_scan(regex, string) do
    Regex.scan(regex, string)
    |> hd()
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
  end
end
