defmodule Aoc.Day13 do
  alias Aoc.Utils

  @regex_button ~r/^Button [A|B]: X\+(\d+), Y\+(\d+)$/
  @regex_prize ~r/^Prize: X=(\d+), Y=(\d+)$/

  defp parse_line(line, regex) do
    Regex.scan(regex, line)
    |> hd()
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_game(game) do
    [button_a, button_b, prize] = String.split(game, "\n")
    [ax, ay] = parse_line(button_a, @regex_button)
    [bx, by] = parse_line(button_b, @regex_button)
    [px, py] = parse_line(prize, @regex_prize)

    %{
      ax: ax,
      ay: ay,
      bx: bx,
      by: by,
      px: px,
      py: py,
      ppx: 10_000_000_000_000 + px,
      ppy: 10_000_000_000_000 + py
    }
  end

  defp solve_equation(%{ax: ax, ay: ay, bx: bx, by: by, px: px, py: py} = game) do
    ax = ax * by
    px = px * by
    ay = ay * bx
    py = py * bx

    left_side = ax - ay
    right_side = px - py

    a_tokens = right_side / left_side
    remainder = game.px - a_tokens * game.ax
    b_tokens = remainder / game.bx

    case round(a_tokens) == a_tokens and round(b_tokens) == b_tokens do
      true -> round(a_tokens * 3 + b_tokens)
      false -> :no_solution
    end
  end

  defp parse_input(file), do: Utils.read_file(file) |> Enum.map(&parse_game/1)

  def solve_a(file \\ "day13.txt") do
    parse_input(file)
    |> Enum.map(&solve_equation/1)
    |> Enum.reject(fn v -> v == :no_solution end)
    |> Enum.sum()
  end

  def solve_b(file \\ "day13.txt") do
    parse_input(file)
    |> Enum.map(fn game -> Map.put(game, :px, game.ppx) |> Map.put(:py, game.ppy) end)
    |> Enum.map(&solve_equation/1)
    |> Enum.reject(fn v -> v == :no_solution end)
    |> Enum.sum()
  end
end
