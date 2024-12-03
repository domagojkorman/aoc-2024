defmodule Aoc.Day02 do
  alias Aoc.Utils

  defp parse_line(line), do: String.split(line, " ") |> Enum.map(&String.to_integer/1)

  defp compare_levels(level1, level2, type) do
    diff = abs(level1 - level2)
    is_correct_type = (type == :asc and level1 < level2) or (type == :desc and level1 > level2)
    diff <= 3 and is_correct_type
  end

  defp validate_levels(levels) do
    type = if Enum.at(levels, 0) > Enum.at(levels, 1), do: :desc, else: :asc

    Enum.drop(levels, -1)
    |> Enum.with_index()
    |> Enum.all?(fn {level, index} ->
      next = Enum.at(levels, index + 1)
      compare_levels(level, next, type)
    end)
  end

  defp validate_sublevels(levels) do
    valid_sublevels =
      Enum.with_index(levels)
      |> Enum.map(fn {_value, index} ->
        validate_levels(List.delete_at(levels, index))
      end)
      |> Enum.count(fn v -> v end)

    if valid_sublevels >= 1, do: true, else: false
  end

  defp validate_levels_with_error(levels) do
    is_valid = validate_levels(levels)
    if is_valid, do: is_valid, else: validate_sublevels(levels)
  end

  @doc """
  iex> Aoc.Day02.solve_a("example02.txt")
  2
  iex> Aoc.Day02.solve_a()
  559
  """
  def solve_a(file \\ "day02.txt") do
    Utils.stream_file(file)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&validate_levels/1)
    |> Enum.filter(fn v -> v end)
    |> Enum.count()
  end

  @doc """
  iex> Aoc.Day02.solve_b("example02.txt")
  5
  iex> Aoc.Day02.solve_b()
  601
  """
  def solve_b(file \\ "day02.txt") do
    Utils.stream_file(file)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&validate_levels_with_error/1)
    |> Enum.count(fn v -> v end)
  end
end
