defmodule Aoc.Day15 do
  alias Aoc.Utils

  defp map_movement(movement) do
    case movement do
      "^" -> :up
      "<" -> :left
      ">" -> :right
      "v" -> :down
    end
  end

  defp get_big_boxes(warehouse, coord, direction, boxes) do
    cond do
      direction == :left or direction == :right ->
        next = Utils.next_coordinate(coord, direction)
        get_boxes(warehouse, next, direction, [coord | boxes])

      true ->
        value = Map.get(warehouse, coord)

        other_coord =
          if value == "[",
            do: Utils.next_coordinate(coord, :right),
            else: Utils.next_coordinate(coord, :left)

        boxes = [coord, other_coord] ++ boxes

        {curr_action, curr_boxes} =
          get_boxes(warehouse, Utils.next_coordinate(coord, direction), direction, boxes)

        {other_action, other_boxes} =
          get_boxes(warehouse, Utils.next_coordinate(other_coord, direction), direction, [])

        cond do
          curr_action == :push and other_action == :push -> {:push, curr_boxes ++ other_boxes}
          true -> {:stop, []}
        end
    end
  end

  defp get_boxes(warehouse, coord, direction, boxes) do
    value = Map.get(warehouse, coord)

    case value do
      "." ->
        {:push, boxes}

      "#" ->
        {:stop, boxes}

      "O" ->
        next = Utils.next_coordinate(coord, direction)
        get_boxes(warehouse, next, direction, [coord | boxes])

      "[" ->
        get_big_boxes(warehouse, coord, direction, boxes)

      "]" ->
        get_big_boxes(warehouse, coord, direction, boxes)
    end
  end

  defp move_boxes(warehouse, robot, direction) do
    next = Utils.next_coordinate(robot, direction)
    {action, boxes} = get_boxes(warehouse, next, direction, [])

    case action do
      :stop ->
        {warehouse, robot}

      :push ->
        new_warehouse =
          Enum.reduce(boxes, warehouse, fn box, new_warehouse ->
            Map.put(new_warehouse, box, ".")
          end)

        new_warehouse =
          Enum.reduce(boxes, new_warehouse, fn box, new_warehouse ->
            next = Utils.next_coordinate(box, direction)
            value = Map.get(warehouse, box)
            Map.put(new_warehouse, next, value)
          end)

        {new_warehouse, next}
    end
  end

  defp move(warehouse, robot, direction) do
    next_coord = Utils.next_coordinate(robot, direction)
    next_value = Map.get(warehouse, next_coord)

    case(next_value) do
      "." -> {warehouse, next_coord}
      "#" -> {warehouse, robot}
      "O" -> move_boxes(warehouse, robot, direction)
      "[" -> move_boxes(warehouse, robot, direction)
      "]" -> move_boxes(warehouse, robot, direction)
    end
  end

  defp resize_warehouse(warehouse) do
    String.replace(warehouse, "#", "##")
    |> String.replace("O", "[]")
    |> String.replace(".", "..")
    |> String.replace("@", "@.")
  end

  defp parse_input(file, resize \\ false) do
    [warehouse, movements] = Utils.read_file(file)
    warehouse = if resize, do: resize_warehouse(warehouse), else: warehouse
    warehouse = Utils.parse_grid(warehouse)

    movements =
      String.replace(movements, "\n", "") |> String.graphemes() |> Enum.map(&map_movement/1)

    robot = Enum.find(warehouse, fn {_k, v} -> v == "@" end) |> elem(0)
    warehouse = Map.put(warehouse, robot, ".")

    {robot, warehouse, movements}
  end

  def solve(file) do
    {robot, warehouse, movements} = parse_input(file)

    Enum.reduce(movements, {warehouse, robot}, fn movement, {warehouse, robot} ->
      move(warehouse, robot, movement)
    end)
    |> elem(0)
    |> Enum.map(fn {{row, col}, v} ->
      if v == "O", do: row * 100 + col, else: 0
    end)
    |> Enum.sum()
  end

  def solve_a(file \\ "day15.txt") do
    {robot, warehouse, movements} = parse_input(file)

    Enum.reduce(movements, {warehouse, robot}, fn movement, {warehouse, robot} ->
      move(warehouse, robot, movement)
    end)
    |> elem(0)
    |> Enum.map(fn {{row, col}, v} ->
      if v == "O", do: row * 100 + col, else: 0
    end)
    |> Enum.sum()
  end

  def solve_b(file \\ "day15.txt") do
    {robot, warehouse, movements} = parse_input(file, true)

    Enum.reduce(movements, {warehouse, robot}, fn movement, {warehouse, robot} ->
      move(warehouse, robot, movement)
    end)
    |> elem(0)
    |> Enum.map(fn {{row, col}, v} ->
      if v == "[", do: row * 100 + col, else: 0
    end)
    |> Enum.sum()
  end
end
