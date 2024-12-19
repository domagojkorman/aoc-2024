defmodule Aoc.Day19 do
  alias Aoc.Utils

  defp parse_input(file) do
    [colors, towels] = Utils.read_file(file)

    colors =
      String.split(colors, ", ")
      |> Enum.reduce(%{}, fn color, color_map ->
        Map.update(color_map, String.at(color, 0), [color], &[color | &1])
      end)

    towels = String.split(towels, "\n")
    {colors, towels}
  end

  defp combine_towel(_colors, "", cache), do: {1, cache}

  defp combine_towel(colors, towel, cache) do
    case Map.has_key?(cache, towel) do
      false ->
        {values, updated_cache} =
          Map.get(colors, String.at(towel, 0), [])
          |> Enum.filter(&String.starts_with?(towel, &1))
          |> Enum.map(&String.slice(towel, String.length(&1)..-1//1))
          |> Enum.map_reduce(cache, fn remaining_towel, acc_cache ->
            combine_towel(colors, remaining_towel, acc_cache)
          end)

        total_value = Enum.sum(values)
        {total_value, Map.put(updated_cache, towel, total_value)}

      true ->
        {Map.get(cache, towel), cache}
    end
  end

  def solve_a(file \\ "day19.txt") do
    {colors, towels} = parse_input(file)

    Enum.map_reduce(towels, %{}, fn towel, cache ->
      combine_towel(colors, towel, cache)
    end)
    |> elem(0)
    |> Enum.count(fn v -> v > 0 end)
  end

  def solve_b(file \\ "day19.txt") do
    {colors, towels} = parse_input(file)

    Enum.map_reduce(towels, %{}, fn towel, cache ->
      combine_towel(colors, towel, cache)
    end)
    |> elem(0)
    |> Enum.sum()
  end
end
