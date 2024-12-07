defmodule Aoc.Day07 do
  alias Aoc.Utils

  defp concatenate_ints(v1, v2) do
    string = Integer.to_string(v1) <> Integer.to_string(v2)
    String.to_integer(string)
  end

  defp parse_line(line) do
    [result, values] = String.split(line, ": ")
    result = String.to_integer(result)
    values = String.split(values, " ") |> Enum.map(&String.to_integer/1)
    {values, result}
  end

  defp calculate_valid([hd | tail], result, is_b), do: calculate_valid(tail, result, is_b, [hd])

  defp calculate_valid([], result, _is_b, current) do
    case Enum.any?(current, fn c -> c === result end) do
      true -> result
      false -> 0
    end
  end

  defp calculate_valid([hd | tail], result, is_b, current) do
    multiplies = Enum.map(current, fn value -> value * hd end)
    sums = Enum.map(current, fn value -> value + hd end)
    concatenations = if is_b, do: Enum.map(current, &concatenate_ints(&1, hd)), else: []
    calculate_valid(tail, result, is_b, multiplies ++ sums ++ concatenations)
  end

  defp solve_task(file, part) do
    is_b = part == :b

    Utils.stream_file(file)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {values, result} ->
      calculate_valid(values, result, is_b)
    end)
    |> Enum.sum()
  end

  def solve_a(file \\ "day07.txt") do
    solve_task(file, :a)
  end

  def solve_b(file \\ "day07.txt") do
    solve_task(file, :b)
  end
end
