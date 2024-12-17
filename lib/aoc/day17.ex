defmodule Aoc.Day17 do
  alias Aoc.Utils

  @regex_register ~r/^Register [A-Z]: (\d+)$/

  defp parse_input(file) do
    [registers, program] = Utils.read_file(file)

    [a, b, c] =
      String.split(registers, "\n") |> Enum.flat_map(&Utils.regex_scan(@regex_register, &1))

    program =
      String.slice(program, 9..-1//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {a, b, c, program}
  end

  defp exec_program(ins, operand, {a, b, c, _}) do
    combo_operand =
      case operand do
        4 -> a
        5 -> b
        6 -> c
        _ -> operand
      end

    case ins do
      0 ->
        a = Integer.floor_div(a, 2 ** combo_operand)
        {:store, {a, b, c}}

      1 ->
        b = Bitwise.bxor(b, operand)
        {:store, {a, b, c}}

      2 ->
        b = Integer.mod(combo_operand, 8)
        {:store, {a, b, c}}

      3 ->
        case a do
          0 ->
            {:store, {a, b, c}}

          _ ->
            {:jump, operand}
        end

      4 ->
        b = Bitwise.bxor(b, c)
        {:store, {a, b, c}}

      5 ->
        {:output, Integer.mod(combo_operand, 8)}

      6 ->
        b = Integer.floor_div(a, 2 ** combo_operand)
        {:store, {a, b, c}}

      7 ->
        c = Integer.floor_div(a, 2 ** combo_operand)
        {:store, {a, b, c}}
    end
  end

  defp run_program({_a, _b, _c, program}, pointer, output) when pointer >= length(program) - 1 do
    output
  end

  defp run_program({_a, _b, _c, program} = memory, pointer, output) do
    [ins, operand | _rest] = Enum.drop(program, pointer)

    case exec_program(ins, operand, memory) do
      {:jump, pointer} -> run_program(memory, pointer, output)
      {:output, value} -> run_program(memory, pointer + 2, [value | output])
      {:store, {a, b, c}} -> run_program({a, b, c, program}, pointer + 2, output)
    end
  end

  defp run_backwards(program, step, result) when step > length(program),
    do: Integer.floor_div(result, 8)

  defp run_backwards(program, step, result) do
    wanted = program |> Enum.take(-step) |> Enum.join(",")

    result =
      Enum.find(result..(result * 8), fn a ->
        output =
          run_program({a, 0, 0, program}, 0, [])
          |> Enum.reverse()
          |> Enum.join(",")

        output == wanted
      end)

    run_backwards(program, step + 1, result * 8)
  end

  def solve_a(file \\ "day17.txt") do
    parse_input(file)
    |> run_program(0, [])
    |> Enum.reverse()
    |> Enum.join(",")
  end

  def solve_b(file \\ "day17.txt") do
    {_a, _b, _c, program} = parse_input(file)

    run_backwards(program, 1, 1)
  end
end
