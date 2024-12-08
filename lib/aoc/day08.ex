defmodule Aoc.Day08 do
  alias Aoc.Utils

  def point_on_line?({px, py}, {x1, y1}, {x2, y2}) do
    (x2 - x1) * (py - y1) == (y2 - y1) * (px - x1)
  end

  defp get_pairs(coords, pairs \\ [])
  defp get_pairs([], pairs), do: pairs

  defp get_pairs([hd | tail], pairs) do
    new_pairs = for coord <- tail, do: {hd, coord}
    get_pairs(tail, pairs ++ new_pairs)
  end

  defp parse_file(file) do
    content = Utils.read_file(file) |> Enum.at(0) |> String.split("\n")
    rows = length(content)
    cols = Enum.at(content, 0) |> String.length()

    map =
      Enum.with_index(content)
      |> Enum.reduce(%{}, fn {line, row}, map ->
        String.graphemes(line)
        |> Enum.with_index()
        |> Enum.reduce(map, fn {c, col}, map ->
          case String.match?(c, ~r/[\dA-Za-z]/) do
            true -> Map.update(map, c, [{row, col}], &[{row, col} | &1])
            false -> map
          end
        end)
      end)

    {rows, cols, map}
  end

  defp is_coordinate_valid?({row, col}, {rows, cols}) do
    row in 0..(rows - 1) and col in 0..(cols - 1)
  end

  def solve_a(file \\ "day08.txt") do
    {rows, cols, map} = parse_file(file)

    Map.values(map)
    |> Enum.flat_map(&get_pairs/1)
    |> Enum.flat_map(fn {{r1, c1}, {r2, c2}} ->
      new_r1 = 2 * r2 - r1
      new_r2 = 2 * r1 - r2
      new_c1 = 2 * c2 - c1
      new_c2 = 2 * c1 - c2
      [{new_r1, new_c1}, {new_r2, new_c2}]
    end)
    |> Enum.uniq()
    |> Enum.count(&is_coordinate_valid?(&1, {rows, cols}))
  end

  def solve_b(file \\ "day08.txt") do
    {rows, cols, map} = parse_file(file)

    Map.values(map)
    |> Enum.flat_map(&get_pairs/1)
    |> Enum.flat_map(fn {p1, p2} ->
      for row <- 0..(rows - 1), col <- 0..(cols - 1) do
        case(point_on_line?({row, col}, p1, p2)) do
          true -> {row, col}
          false -> nil
        end
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
    |> Enum.count(&is_coordinate_valid?(&1, {rows, cols}))
  end
end
