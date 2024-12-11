defmodule Aoc.Day11 do
  alias Aoc.Utils

  @leading_zeroes_regex ~r/^0*(?=\d)/

  defp parse_input(file) do
    Utils.read_file(file) |> hd() |> String.split("\n") |> hd() |> String.split(" ")
  end

  defp slice_stone(stone) do
    len = String.length(stone)
    center = div(len, 2)
    left = String.slice(stone, 0..(center - 1))
    right = String.slice(stone, center..len) |> String.replace(@leading_zeroes_regex, "")
    [left, right]
  end

  defp mul_2024(stone) do
    String.to_integer(stone) |> Kernel.*(2024) |> Integer.to_string()
  end

  defp apply_rule(stone) do
    len = String.length(stone)
    is_even_digits = rem(len, 2) == 0

    cond do
      stone == "0" -> ["1"]
      is_even_digits -> slice_stone(stone)
      true -> [mul_2024(stone)]
    end
  end

  defp stone_with_prev_freq({stone, freq}) do
    apply_rule(stone) |> Enum.map(&{&1, freq})
  end

  defp apply_rule_with_step(stone_freq, steps) do
    Enum.reduce(1..steps, stone_freq, fn _, stone_freq ->
      Enum.flat_map(stone_freq, &stone_with_prev_freq/1)
      |> Enum.reduce(%{}, fn {stone, freq}, new_freq ->
        Map.update(new_freq, stone, freq, &(&1 + freq))
      end)
    end)
  end

  def solve_a(file \\ "day11.txt") do
    input = parse_input(file) |> Enum.map(fn v -> {v, 1} end)
    apply_rule_with_step(input, 25) |> Map.values() |> Enum.sum()
  end

  def solve_b(file \\ "day11.txt") do
    input = parse_input(file) |> Enum.map(fn v -> {v, 1} end)
    apply_rule_with_step(input, 75) |> Map.values() |> Enum.sum()
  end
end
