defmodule Aoc.Day06 do
  alias Aoc.Utils

  defp rotate(direction) do
    case direction do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  defp walk(map, loc, direction, visited) do
    next_loc = Utils.next_coordinate(loc, direction)
    directions = Map.get(visited, loc, [])
    new_visited = Map.update(visited, loc, [direction], &[direction | &1])
    next_value = Map.get(map, next_loc)

    cond do
      Enum.member?(directions, direction) -> :loop
      next_value == "#" -> walk(map, loc, rotate(direction), visited)
      next_value == nil -> new_visited
      true -> walk(map, next_loc, direction, new_visited)
    end
  end

  defp parse_input(file) do
    map =
      Utils.stream_file(file)
      |> Enum.map(&String.graphemes/1)
      |> Utils.grid_to_map()

    starting_loc = Enum.find(map, fn {_key, value} -> value == "^" end) |> elem(0)
    {map, starting_loc}
  end

  def solve_a(file \\ "day06.txt") do
    {map, starting_loc} = parse_input(file)

    walk(map, starting_loc, :up, %{})
    |> Enum.count()
  end

  def solve_b(file \\ "day06.txt") do
    {map, starting_loc} = parse_input(file)

    walk(map, starting_loc, :up, %{})
    |> Enum.flat_map(fn {loc, directions} ->
      Enum.map(directions, &Utils.next_coordinate(loc, &1))
    end)
    |> Enum.uniq()
    |> Enum.filter(fn loc -> Map.get(map, loc) == "." end)
    |> Enum.map(fn loc ->
      Task.async(fn ->
        map_with_obstruction = Map.put(map, loc, "#")
        walk(map_with_obstruction, starting_loc, :up, %{})
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.count(fn v -> v == :loop end)
  end
end
