defmodule Aoc.Day16 do
  alias Aoc.Utils

  defp parse_input(file) do
    map = Utils.read_file(file) |> hd() |> Utils.parse_grid()
    {maze_start, _} = Enum.find(map, fn {_k, v} -> v == "S" end)
    {map, maze_start}
  end

  defp rotate_value(dir, new_dir) do
    dirs = [:left, :up, :right, :down]
    dir_index = Enum.find_index(dirs, fn d -> d == dir end)
    new_dir_index = Enum.find_index(dirs, fn d -> d == new_dir end)
    diff = abs(dir_index - new_dir_index)

    cond do
      dir_index == new_dir_index -> 1
      diff == 1 or diff == 3 -> 1001
      diff == 2 -> 2001
    end
  end

  defp all_possibilities(map, {coord, dir, value, steps}, visited) do
    Enum.map([:left, :up, :down, :right], fn new_dir ->
      new_coord = Utils.next_coordinate(coord, new_dir)
      new_value = value + rotate_value(dir, new_dir)
      {new_coord, new_dir, new_value, [new_coord | steps]}
    end)
    |> Enum.reject(fn {new_coord, _, _, _} ->
      Map.get(map, new_coord) == "#"
    end)
    |> Enum.reject(fn {new_coord, new_dir, _, _} ->
      Map.has_key?(visited, Tuple.append(new_coord, new_dir))
    end)
  end

  defp walk(map, [{coord, dir, value, steps} = loc | tail], visited, paths, best_path) do
    cond do
      best_path != nil and value > best_path ->
        {best_path, paths}

      Map.get(map, coord) == "E" ->
        walk(map, tail, visited, [steps | paths], value)

      true ->
        pos = all_possibilities(map, loc, visited)
        visited = Map.put(visited, Tuple.append(coord, dir), value)
        array = (tail ++ pos) |> Enum.sort_by(fn {_coord, _dir, value, _steps} -> value end)
        walk(map, array, visited, paths, best_path)
    end
  end

  def solve_a(file \\ "day16.txt") do
    {map, maze_start} = parse_input(file)

    walk(map, [{maze_start, :right, 0, []}], %{}, [], nil)
    |> elem(0)
  end

  def solve_b(file \\ "day16.txt") do
    {map, maze_start} = parse_input(file)

    walk(map, [{maze_start, :right, 0, [{maze_start}]}], %{}, [], nil)
    |> elem(1)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end
end
