defmodule Aoc.Day10 do
  alias Aoc.Utils

  defp parse_input(file) do
    Utils.stream_file(file)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, map ->
      String.graphemes(line)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {value, col}, acc ->
        Map.put(acc, {row, col}, value)
      end)
    end)
  end

  defp walk_uphill_with_visited(_map, [], _visited, result), do: result

  defp walk_uphill_with_visited(map, [hd | tail], visited, result) do
    {coord, value} = hd

    next_coordinates =
      Utils.next_coordinates(coord)
      |> Enum.filter(fn c -> not Map.has_key?(visited, c) end)
      |> Enum.map(fn c -> {c, Map.get(map, c, -1)} end)
      |> Enum.filter(fn {_c, v} -> v == value + 1 end)

    visited = Enum.reduce(next_coordinates, visited, fn {c, _v}, acc -> Map.put(acc, c, true) end)

    result = if value == 9, do: result + 1, else: result

    walk_uphill_with_visited(map, next_coordinates ++ tail, visited, result)
  end

  defp walk_uphill(_map, [], result), do: result

  defp walk_uphill(map, [hd | tail], result) do
    {coord, value} = hd

    next_coordinates =
      Utils.next_coordinates(coord)
      |> Enum.map(fn c -> {c, Map.get(map, c, -1)} end)
      |> Enum.filter(fn {_c, v} -> v == value + 1 end)

    result = if value == 9, do: result + 1, else: result

    walk_uphill(map, next_coordinates ++ tail, result)
  end

  def solve_a(file \\ "day10.txt") do
    map = parse_input(file)

    Map.filter(map, fn {_key, value} -> value == 0 end)
    |> Enum.map(&walk_uphill_with_visited(map, [&1], %{}, 0))
    |> Enum.sum()
  end

  def solve_b(file \\ "day10.txt") do
    map = parse_input(file)

    Map.filter(map, fn {_key, value} -> value == 0 end)
    |> Enum.map(&walk_uphill(map, [&1], 0))
    |> Enum.sum()
  end
end
