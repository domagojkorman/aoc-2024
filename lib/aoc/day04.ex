defmodule Aoc.Day04 do
  alias Aoc.Utils

  defp get_word(_, _, 0, _, word), do: word

  defp get_word(map, coord, steps, direction, word) do
    value = Map.get(map, coord, ".")
    next_coord = Utils.next_coordinate(coord, direction)
    get_word(map, next_coord, steps - 1, direction, word <> value)
  end

  defp input_as_map(file) do
    Utils.stream_file(file)
    |> Enum.map(&String.graphemes/1)
    |> Utils.matrix_to_map()
  end

  defp check_word(direction, map, coord, word) do
    steps = String.length(word)

    case get_word(map, coord, steps, direction, "") do
      ^word -> 1
      _ -> 0
    end
  end

  @doc """
  iex> Aoc.Day04.solve_a("example04.txt")
  18
  iex> Aoc.Day04.solve_a()
  2554
  """
  def solve_a(file \\ "day04.txt") do
    map = input_as_map(file)

    Map.keys(map)
    |> Enum.flat_map(fn coord ->
      directions = [:up, :left, :down, :right, :up_left, :up_right, :down_left, :down_right]
      Enum.map(directions, &check_word(&1, map, coord, "XMAS"))
    end)
    |> Enum.sum()
  end

  @doc """
  iex> Aoc.Day04.solve_b("example04.txt")
  9
  iex> Aoc.Day04.solve_b()
  1916
  """
  def solve_b(file \\ "day04.txt") do
    map = input_as_map(file)

    Map.keys(map)
    |> Enum.map(fn {row, col} = coord ->
      xcoord = {row, col + 2}
      left_word = get_word(map, coord, 3, :down_right, "")
      right_word = get_word(map, xcoord, 3, :down_left, "")
      is_left_ok = left_word == "MAS" or left_word == "SAM"
      is_right_ok = right_word == "MAS" or right_word == "SAM"
      is_left_ok and is_right_ok
    end)
    |> Enum.count(fn v -> v end)
  end
end
