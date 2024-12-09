defmodule Aoc.Day09 do
  alias Aoc.Utils

  defp parse_input(file) do
    Utils.read_file(file)
    |> Enum.at(0)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      case rem(index, 2) == 0 do
        true -> {div(index, 2), value}
        false -> {:empty, value}
      end
    end)
  end

  defp reorg_array(_array, findex, bindex, result) when findex > bindex, do: result

  defp reorg_array(array, findex, bindex, result) do
    {fvalue, fspaces} = Enum.at(array, findex)
    {bvalue, bspaces} = Enum.at(array, bindex)

    cond do
      bvalue == :empty ->
        reorg_array(array, findex, bindex - 1, result)

      fvalue != :empty ->
        reorg_array(array, findex + 1, bindex, result ++ List.duplicate(fvalue, fspaces))

      fspaces > bspaces ->
        array = List.update_at(array, findex, fn {v, _s} -> {v, fspaces - bspaces} end)
        reorg_array(array, findex, bindex - 1, result ++ List.duplicate(bvalue, bspaces))

      bspaces > fspaces ->
        array = List.update_at(array, bindex, fn {v, _s} -> {v, bspaces - fspaces} end)
        reorg_array(array, findex + 1, bindex, result ++ List.duplicate(bvalue, fspaces))

      true ->
        reorg_array(array, findex + 1, bindex - 1, result ++ List.duplicate(bvalue, bspaces))
    end
  end

  defp reorg_array_b(array, bindex) when bindex == 0, do: array

  defp reorg_array_b(array, bindex) do
    {bvalue, bspaces} = Enum.at(array, bindex)
    index = Enum.find_index(array, fn v -> elem(v, 0) == :empty and elem(v, 1) >= bspaces end)

    cond do
      bvalue == :empty or index == nil or index >= bindex ->
        reorg_array_b(array, bindex - 1)

      true ->
        array =
          List.update_at(array, index, fn {v, s} -> {v, s - bspaces} end)
          |> List.update_at(bindex, fn {_v, s} -> {:empty, s} end)
          |> List.insert_at(index, {bvalue, bspaces})

        reorg_array_b(array, bindex)
    end
  end

  def solve_a(file \\ "day09.txt") do
    input = parse_input(file)

    reorg_array(input, 0, length(input) - 1, [])
    |> Enum.with_index()
    |> Enum.map(fn {v, index} -> v * index end)
    |> Enum.sum()
  end

  def solve_b(file \\ "day09.txt") do
    input = parse_input(file)

    reorg_array_b(input, length(input) - 1)
    |> Enum.flat_map(fn {v, s} ->
      List.duplicate(v, s)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      case value do
        :empty -> 0
        _ -> value * index
      end
    end)
    |> Enum.sum()
  end
end
