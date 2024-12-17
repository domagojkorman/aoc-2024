defmodule Aoc do
  @modules [
    Aoc.Day01,
    Aoc.Day02,
    Aoc.Day03,
    Aoc.Day04,
    Aoc.Day05,
    Aoc.Day06,
    Aoc.Day07,
    Aoc.Day08,
    Aoc.Day09,
    Aoc.Day10,
    Aoc.Day11,
    Aoc.Day12,
    Aoc.Day13,
    Aoc.Day14,
    Aoc.Day15,
    Aoc.Day16,
    Aoc.Day17
  ]

  defp create_tasks(module) do
    [
      {module, :solve_a, []},
      {module, :solve_b, []}
    ]
  end

  defp run_task({module, fun, args}) do
    Task.async(fn ->
      :timer.tc(module, fun, args)
    end)
  end

  defp print_output({{time, result}, index}) do
    real_index = floor(index / 2) + 1
    part = if rem(index, 2) == 0, do: "A", else: "B"
    seconds = (time / 1_000_000) |> Float.round(3)

    IO.puts(
      "Solution \##{real_index |> Integer.to_string() |> String.pad_leading(2, "0")}#{part} in #{seconds}s: #{result}"
    )
  end

  def run_solutions do
    {time, _} =
      :timer.tc(fn ->
        @modules
        |> Enum.flat_map(&create_tasks/1)
        |> Enum.map(&run_task/1)
        |> Enum.map(&Task.await(&1, :timer.seconds(10)))
        |> Enum.with_index(0)
        |> Enum.each(&print_output/1)
      end)

    seconds = (time / 1_000_000) |> Float.round(3)
    IO.puts("All solutions done in #{seconds}s")
  end
end
