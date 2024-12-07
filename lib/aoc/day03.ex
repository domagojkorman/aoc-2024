defmodule Aoc.Day03 do
  alias Aoc.Utils

  @regex ~r/mul\((?<first>\d+),(?<second>\d+)\)/
  @regexb ~r/mul\(\d+,\d+\)|do\(\)|don't\(\)/

  defp mul_captures([first, second]) do
    String.to_integer(first) * String.to_integer(second)
  end

  defp mul_with_switch(["don't()"], {acc, _is_on}), do: {acc, false}
  defp mul_with_switch(["do()"], {acc, _is_on}), do: {acc, true}
  defp mul_with_switch(_, {_acc, false} = result), do: result

  defp mul_with_switch([mul], {acc, is_on}) do
    [first, second] =
      String.replace_prefix(mul, "mul(", "")
      |> String.replace_suffix(")", "")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {acc + first * second, is_on}
  end

  def solve_a(file \\ "day03.txt") do
    Utils.stream_file(file)
    |> Enum.flat_map(&Regex.scan(@regex, &1, capture: :all_names))
    |> Enum.map(&mul_captures/1)
    |> Enum.sum()
  end

  def solve_b(file \\ "day03.txt") do
    Utils.stream_file(file)
    |> Enum.flat_map(&Regex.scan(@regexb, &1))
    |> Enum.reduce({0, true}, &mul_with_switch/2)
    |> elem(0)
  end
end
