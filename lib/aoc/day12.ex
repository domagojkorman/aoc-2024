defmodule Aoc.Day12 do
  alias Aoc.Utils

  defp parse_input(file) do
    Utils.read_file(file)
    |> hd()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Utils.grid_to_map()
  end

  defp is_neighbour({r1, c1}, {r2, c2}) do
    abs(r1 - r2) + abs(c1 - c2) == 1
  end

  defp group_neighbours(coords) do
    Enum.reduce(coords, [], fn coord, groups ->
      {neighbouring_groups, others} =
        Enum.split_with(groups, fn group -> Enum.any?(group, &is_neighbour(coord, &1)) end)

      merged_group = Enum.concat([coord], Enum.concat(neighbouring_groups))
      [merged_group | others]
    end)
  end

  defp calculate_region_sides(garden, region) do
    region_sides =
      Enum.reduce(region, %{}, fn coord, fences ->
        new_fences =
          [:up, :down, :left, :right]
          |> Enum.map(fn d -> {d, Utils.next_coordinate(coord, d)} end)
          |> Enum.filter(fn {_d, c} -> Map.get(garden, c) != Map.get(garden, coord) end)
          |> Enum.into(%{}, fn {k, _v} -> {k, [coord]} end)

        Map.merge(fences, new_fences, fn _k, v1, v2 -> v1 ++ v2 end)
      end)

    up_fences = group_neighbours(region_sides.up) |> Enum.count()
    down_fences = group_neighbours(region_sides.down) |> Enum.count()
    left_fences = group_neighbours(region_sides.left) |> Enum.count()
    right_fences = group_neighbours(region_sides.right) |> Enum.count()
    up_fences + down_fences + left_fences + right_fences
  end

  defp calculate_region_perimeter(garden, coords) do
    Enum.reduce(coords, 0, fn coord, acc ->
      acc + calculate_perimeter(garden, coord)
    end)
  end

  defp calculate_perimeter(garden, coord) do
    plant = Map.get(garden, coord)

    Utils.next_coordinates(coord)
    |> Enum.map(&Map.get(garden, &1))
    |> Enum.count(&(&1 != plant))
  end

  defp group_region(_garden, _plant, [], visited, region), do: {region, visited}

  defp group_region(garden, plant, [coord | tail], visited, region) do
    case Map.has_key?(visited, coord) do
      true ->
        group_region(garden, plant, tail, visited, region)

      false ->
        new_coords =
          Utils.next_coordinates(coord)
          |> Enum.filter(fn c -> Map.get(garden, c) == plant end)

        visited = Map.put(visited, coord, true)
        region = if Map.get(garden, coord) == plant, do: [coord | region], else: region
        group_region(garden, plant, tail ++ new_coords, visited, region)
    end
  end

  def solve_a(file \\ "day12.txt") do
    garden = parse_input(file)

    Enum.reduce(garden, {[], %{}}, fn {coord, plant}, {regions, visited} ->
      {new_region, visited} = group_region(garden, plant, [coord], visited, [])
      {[new_region | regions], visited}
    end)
    |> elem(0)
    |> Enum.reject(fn v -> length(v) == 0 end)
    |> Enum.map(fn region -> length(region) * calculate_region_perimeter(garden, region) end)
    |> Enum.sum()
  end

  def solve_b(file \\ "day12.txt") do
    garden = parse_input(file)

    Enum.reduce(garden, {[], %{}}, fn {coord, plant}, {regions, visited} ->
      {new_region, visited} = group_region(garden, plant, [coord], visited, [])
      {[new_region | regions], visited}
    end)
    |> elem(0)
    |> Enum.reject(fn v -> length(v) == 0 end)
    |> Enum.map(fn region -> length(region) * calculate_region_sides(garden, region) end)
    |> Enum.sum()
  end
end
