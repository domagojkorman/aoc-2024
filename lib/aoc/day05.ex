defmodule Aoc.Day05 do
  alias Aoc.Utils

  defp group_ordering(orderings) do
    String.split(orderings, "\n")
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.group_by(
      fn [left, _right] -> left end,
      fn [_left, right] -> right end
    )
  end

  defp filter_ordering_map(orderings, row) do
    used_values = String.split(row, ",")

    Enum.filter(orderings, fn {k, _v} -> Enum.member?(used_values, k) end)
    |> Enum.map(fn {k, values} ->
      filtered_values = Enum.filter(values, fn v -> Enum.member?(used_values, v) end)
      {k, filtered_values |> length()}
    end)
    |> Enum.into(%{})
  end

  defp sort_row(row, orderings) do
    filtered_ordering = filter_ordering_map(orderings, row)

    String.split(row, ",")
    |> Enum.map(fn value -> {value, Map.get(filtered_ordering, value, 0)} end)
    |> Enum.sort_by(fn {_v, order} -> order end, :desc)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join(",")
  end

  @doc """
  iex> Aoc.Day05.solve_a("example05.txt")
  143
  iex> Aoc.Day05.solve_a()
  5166
  """
  def solve_a(file \\ "day05.txt") do
    [orderings, prints] = Utils.read_file(file)
    orderings = group_ordering(orderings)

    String.split(prints, "\n")
    |> Enum.map(fn row -> {row, sort_row(row, orderings)} end)
    |> Enum.filter(fn {row, sorted_row} -> row == sorted_row end)
    |> Enum.map(fn {row, _} ->
      values = String.split(row, ",") |> Enum.map(&String.to_integer/1)
      Enum.at(values, div(length(values), 2))
    end)
    |> Enum.sum()
  end

  @doc """
  iex> Aoc.Day05.solve_b("example05.txt")
  123
  iex> Aoc.Day05.solve_b()
  4679
  """
  def solve_b(file \\ "day05.txt") do
    [orderings, prints] = Utils.read_file(file)
    orderings = group_ordering(orderings)

    String.split(prints, "\n")
    |> Enum.map(fn row -> {row, sort_row(row, orderings)} end)
    |> Enum.filter(fn {row, sorted_row} -> row != sorted_row end)
    |> Enum.map(fn {_row, sorted_row} ->
      values = String.split(sorted_row, ",") |> Enum.map(&String.to_integer/1)
      Enum.at(values, div(length(values), 2))
    end)
    |> Enum.sum()
  end
end
