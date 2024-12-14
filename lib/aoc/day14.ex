defmodule Aoc.Day14 do
  alias Aoc.Utils

  @regex_line ~r/^p=(\d+),(\d+) v=(-?\d+),(-?\d+)$/
  @width 101
  @height 103

  defp parse_input(file) do
    Utils.stream_file(file) |> Enum.map(&Utils.regex_scan(@regex_line, &1))
  end

  defp calculate_position([x, y, vx, vy], seconds) do
    x = rem(vx * seconds + x, @width)
    y = rem(vy * seconds + y, @height)
    x = if x >= 0, do: x, else: @width + x
    y = if y >= 0, do: y, else: @height + y
    {x, y}
  end

  defp calculate_quadrant({x, y}) do
    cond do
      x == div(@width, 2) or y == div(@height, 2) -> :none
      x < @width / 2 and y < @height / 2 -> :first
      x > @width / 2 and y < @height / 2 -> :second
      x < @width / 2 -> :third
      true -> :fourth
    end
  end

  defp calculate_tree_score({_seconds, freq}) do
    Map.keys(freq)
    |> Enum.map(fn coord ->
      Utils.next_coordinates(coord, true) |> Enum.count(&Map.has_key?(freq, &1))
    end)
    |> Enum.sum()
  end

  # defp print_out({_seconds, freq}) do
  #   Enum.each(0..(@height - 1), fn row ->
  #     line =
  #       Enum.map(0..(@width - 1), fn col ->
  #         Map.get(freq, {col, row}, ".")
  #       end)

  #     IO.puts(Enum.join(line, ""))
  #   end)
  # end

  def solve_a(file \\ "day14.txt") do
    parse_input(file)
    |> Enum.map(&calculate_position(&1, 100))
    |> Enum.map(&calculate_quadrant/1)
    |> Enum.frequencies()
    |> Enum.map(fn {k, v} -> if k != :none, do: v, else: 1 end)
    |> Enum.reduce(1, fn c, mul -> c * mul end)
  end

  def solve_b(file \\ "day14.txt") do
    input = parse_input(file)

    tree =
      Enum.map(1..10000, fn seconds ->
        freq = Enum.map(input, &calculate_position(&1, seconds)) |> Enum.frequencies()
        {seconds, freq}
      end)
      |> Enum.sort_by(&calculate_tree_score/1, :desc)
      |> hd

    # print_out(tree)
    elem(tree, 0)
  end
end
