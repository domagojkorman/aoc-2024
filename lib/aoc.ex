defmodule Aoc do
  @modules [
    Aoc.Day01,
    Aoc.Day02,
    Aoc.Day03,
    Aoc.Day04,
    Aoc.Day05
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
    IO.puts("Solution \##{real_index}#{part} in #{seconds}s: #{result}")
  end

  def run_solutions do
    @modules
    |> Enum.flat_map(&create_tasks/1)
    |> Enum.map(&run_task/1)
    |> Enum.map(&Task.await/1)
    |> Enum.with_index(0)
    |> Enum.each(&print_output/1)
  end
end
