defmodule Aoc.Day18 do
  alias Aoc.Utils

  @grid 70

  defp parse_input(file) do
    Utils.stream_file(file)
    |> Enum.map(fn line ->
      String.split(line, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  defp walk(_grid, [], _visited), do: :error

  defp walk(grid, [{{row, col}, prev_steps} | tail], visited) do
    cond do
      row == @grid and col == @grid ->
        [{row, col} | prev_steps]

      Map.has_key?(visited, {row, col}) ->
        walk(grid, tail, visited)

      Map.has_key?(grid, {row, col}) ->
        walk(grid, tail, visited)

      row < 0 or col < 0 or row > @grid or col > @grid ->
        walk(grid, tail, visited)

      true ->
        coord = {row, col}
        visited = Map.put(visited, coord, true)

        next_steps =
          Utils.next_coordinates(coord) |> Enum.map(fn c -> {c, [coord | prev_steps]} end)

        walk(grid, next_steps ++ tail, visited)
    end
  end

  defp find_error(bytes, byte_count, prev_path \\ nil) do
    {x, y} = Enum.at(bytes, byte_count - 1)

    cond do
      prev_path == nil or Map.has_key?(prev_path, {y, x}) ->
        grid = bytes_to_map(bytes, byte_count)
        path = walk(grid, [{{0, 0}, []}], %{})

        case path do
          :error ->
            {x, y}

          _ ->
            prev_path = path |> Enum.into(%{}, fn v -> {v, true} end)
            find_error(bytes, byte_count + 1, prev_path)
        end

      true ->
        find_error(bytes, byte_count + 1, prev_path)
    end
  end

  defp bytes_to_map(bytes, byte_count) do
    bytes
    |> Stream.take(byte_count)
    |> Enum.into(%{}, fn {x, y} -> {{y, x}, "#"} end)
  end

  def solve_a(file \\ "day18.txt") do
    grid = parse_input(file) |> bytes_to_map(1024)
    walk(grid, [{{0, 0}, []}], %{}) |> Enum.drop(1) |> Enum.count()
  end

  def solve_b(file \\ "day18.txt") do
    bytes = parse_input(file)
    {x, y} = find_error(bytes, 1024)
    "#{x},#{y}"
  end
end
