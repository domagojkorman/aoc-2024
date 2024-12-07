#!/usr/bin/env elixir

[day] = System.argv()

padded_day = String.pad_leading(day, 2, "0")
input_name = "day#{padded_day}.txt"
example_name = "example#{padded_day}.txt"
module_name = "Aoc.Day#{padded_day}"

File.write!("./inputs/#{input_name}", "")
File.write!("./inputs/#{example_name}", "")

File.write!("./lib/aoc/day#{padded_day}.ex", """
defmodule #{module_name} do
  alias Aoc.Utils

  @doc \"\"\"
  iex> #{module_name}.solve_a("#{example_name}")
  nil
  \"\"\"
  def solve_a(file \\\\ "#{input_name}") do
  end

  @doc \"\"\"
  \"\"\"
  def solve_b(file \\\\ "#{input_name}") do
  end
end
""")

new_content =
  File.read!("./test/aoc_test.exs")
  |> String.split("\n")
  |> List.insert_at(-3, "  doctest #{module_name}")
  |> Enum.join("\n")

File.write!("./test/aoc_test.exs", new_content)

previous_day = (String.to_integer(day) - 1) |> Integer.to_string() |> String.pad_leading(2, "0")

new_content =
  File.read!("./lib/aoc.ex")
  |> String.split("\n")
  |> List.delete_at(String.to_integer(day))
  |> List.insert_at(String.to_integer(day), "    Aoc.Day#{previous_day},")
  |> List.insert_at(String.to_integer(day) + 1, "    #{module_name}")
  |> Enum.join("\n")

File.write!("./lib/aoc.ex", new_content)
