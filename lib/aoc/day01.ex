defmodule Aoc.Day01 do
  alias Aoc.Utils

  defp parse_line(line, {col1, col2}) do
    [v1, v2] = String.split(line, "   ") |> Enum.map(&String.to_integer/1)
    {[v1 | col1], [v2 | col2]}
  end

  defp zip_columns({col1, col2}), do: Enum.zip(Enum.sort(col1), Enum.sort(col2))
  defp sum_diff({col1, col2}, acc), do: acc + abs(col1 - col2)
  defp sum_similarity(v, acc, occurences), do: acc + Map.get(occurences, v, 0) * v

  @doc """
  iex> Aoc.Day01.solve_a("example01.txt")
  11
  iex> Aoc.Day01.solve_a()
  1722302
  """
  def solve_a(file \\ "day01.txt") do
    Utils.stream_file(file)
    |> Enum.reduce({[], []}, &parse_line/2)
    |> zip_columns()
    |> Enum.reduce(0, &sum_diff/2)
  end

  @doc """
  iex> Aoc.Day01.solve_b("example01.txt")
  31
  iex> Aoc.Day01.solve_b()
  20373490
  """
  def solve_b(file \\ "day01.txt") do
    Utils.stream_file(file)
    |> Enum.reduce({[], []}, &parse_line/2)
    |> then(fn {col1, col2} ->
      occurences = Enum.frequencies(col2)
      Enum.reduce(col1, 0, &sum_similarity(&1, &2, occurences))
    end)
  end
end
