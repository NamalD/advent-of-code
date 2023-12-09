defmodule Day2 do
  @moduledoc """
  Documentation for `Day2`.
  """

  def run_part_one do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.filter(&String.length(&1) > 0)
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&is_possible_game/1)
    |> Enum.map(fn game -> game[:game] end)
    |> Enum.sum
  end

  @doc """
  Check if a game is possible.

  ## Examples

      iex> Day2.is_possible_game(%{game: 1, sets: [%{blue: 3, red: 4}, %{red: 1, green: 2}, %{blue: 6, green: 2}]})
      true
  """
  def is_possible_game(game) do
    game[:sets]
    |> Enum.map(&is_possible_set/1)
    |> Enum.all?
  end

  @doc """
  Check if a set is possible.
  A set is possible if the number of red balls is <= 12 and the number of blue balls is <= 14, and the number of green balls is <= 13.

  ## Examples

      iex> Day2.is_possible_set(%{blue: 3, red: 12})
      true
      iex> Day2.is_possible_set(%{blue: 3, green: 13})
      true
      iex> Day2.is_possible_set(%{blue: 3, blue: 14})
      true
      iex> Day2.is_possible_set(%{blue: 15, red: 4})
      false
      iex> Day2.is_possible_set(%{blue: 1, red: 13})
      false
      iex> Day2.is_possible_set(%{blue: 1, green: 14})
      false
  """
  def is_possible_set(set) do
    red = Map.get(set, :red, 0)
    blue = Map.get(set, :blue, 0)
    green = Map.get(set, :green, 0)
    red <= 12 and green <= 13 and blue <= 14
  end

  @doc """
  Parse game details from a line.

  ## Examples

      iex> Day2.parse_line("Game 1: 3 blue, 4 red; 1 red, 2 green; 6 blue, 2 green")
      %{
        game: 1,
        sets: [
          %{blue: 3, red: 4},
          %{red: 1, green: 2},
          %{blue: 6, green: 2}
        ]
      }
  """
  def parse_line(line) do
    [game, sets] = String.split(line, ": ")
    game = String.replace(game, "Game ", "")
    %{game: String.to_integer(game), sets: parse_sets(sets)}
  end

  @doc """
  Parse sets of balls.

  ## Examples

      iex> Day2.parse_sets("3 blue, 4 red; 1 red, 2 green; 6 blue, 2 green")
      [%{blue: 3, red: 4}, %{red: 1, green: 2}, %{blue: 6, green: 2}]
  """
  def parse_sets(sets) do
    String.split(sets, "; ")
    |> Enum.map(&parse_set/1)
  end

  @doc """
  Parse a set of balls.

  ## Examples

      iex> Day2.parse_set("3 blue, 4 red")
      %{blue: 3, red: 4}
  """
  def parse_set(set) do
    set
    |> String.split(", ")
    |> Enum.map(&parse_ball/1)
    |> Enum.into(%{})
  end

  @doc """
  Parse a ball.

  ## Examples

      iex> Day2.parse_ball("3 blue")
      {:blue, 3}
  """
  def parse_ball(ball) do
    [count, color] = String.split(ball, " ")
    {String.to_atom(color), String.to_integer(count)}
  end

end
