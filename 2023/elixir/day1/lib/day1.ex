defmodule Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """

  def digit_text do
    %{
      "one" => 1,
      "two" => 2,
      "three" => 3,
      "four" => 4,
      "five" => 5,
      "six" => 6,
      "seven" => 7,
      "eight" => 8,
      "nine" => 9
    }
  end

  def run do
    File.read!("calibration.txt")
    |> String.split("\r\n")
    |> Enum.map(fn line -> find_calibration_value(line) end)
    |> Enum.reverse()
    |> Enum.sum()
  end

  @doc """
  Finds the calibration value for a given line by combining the first and last digit.

  ## Examples

      iex> Day1.find_calibration_value("123")
      13
      iex> Day1.find_calibration_value("abc123")
      13
      iex> Day1.find_calibration_value("a1b2c3d")
      13
      iex> Day1.find_calibration_value("a12b")
      12
      iex> Day1.find_calibration_value("a1b")
      11
      iex> Day1.find_calibration_value("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr")
      49
      iex> Day1.find_calibration_value("eightwothree")
      83
      iex> Day1.find_calibration_value("sevenine")
      79
  """
  def find_calibration_value(line) do
    digits = all_digits(line)
    first_digit = find_first_occurrence(line, digits)
    last_digit = find_last_occurrence(line, digits)
    combine_digits(first_digit, last_digit)
  end

  @doc """
  Finds all digits in a line.

  ## Examples

      iex> Day1.all_digits("123")
      [1, 2, 3]
      iex> Day1.all_digits("abc123")
      [1, 2, 3]
      iex> Day1.all_digits("a1b2c3d")
      [1, 2, 3]
      iex> Day1.all_digits("a12b")
      [1, 2]
      iex> Day1.all_digits("a1b")
      [1]
      iex> Day1.all_digits("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr")
      [2, 6, "four", "nine"]
      iex> Day1.all_digits("eightwothree")
      ["two", "three", "eight"]
      iex> Day1.all_digits("sevenine")
      ["seven", "nine"]
  """
  def all_digits(line) do
    all_numeric_digits(line) ++ all_text_digits(line)
  end

  @doc """
  Finds all numeric digits in a line.

  ## Examples

      iex> Day1.all_numeric_digits("123")
      [1, 2, 3]
      iex> Day1.all_numeric_digits("abc123")
      [1, 2, 3]
      iex> Day1.all_numeric_digits("a1b2c3d")
      [1, 2, 3]
      iex> Day1.all_numeric_digits("a12b")
      [1, 2]
      iex> Day1.all_numeric_digits("a1b")
      [1]
      iex> Day1.all_numeric_digits("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr")
      [2, 6]
      iex> Day1.all_numeric_digits("eightwothree")
      []
      iex> Day1.all_numeric_digits("sevenine")
      []
  """
  def all_numeric_digits(line) do
    String.graphemes(line)
    |> Enum.filter(fn grapheme -> String.match?(grapheme, ~r/\d/) end)
    |> Enum.map(fn grapheme -> String.to_integer(grapheme) end)
  end

  @doc """
  Finds all unique text digits in a line. Results are not in order of occurrence.

  ## Examples

      iex> Day1.all_text_digits("123")
      []
      iex> Day1.all_text_digits("abc123")
      []
      iex> Day1.all_text_digits("a1b2c3d")
      []
      iex> Day1.all_text_digits("a12b")
      []
      iex> Day1.all_text_digits("a1b")
      []
      iex> Day1.all_text_digits("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr")
      ["four", "nine"]
      iex> Day1.all_text_digits("eightwothree")
      ["two", "three", "eight"]
      iex> Day1.all_text_digits("sevenine")
      ["seven", "nine"]
  """
  def all_text_digits(line) do
    text_digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    Enum.filter(text_digits, fn text_digit -> String.contains?(line, text_digit) end)
  end

  @doc """
  Finds the first occurrence of a subtext in a line.

  ## Examples
      iex> Day1.find_first_occurrence("123", ["1", "2", "3"])
      "1"
      iex> Day1.find_first_occurrence("213", ["1", "2", "3"])
      "2"
      iex> Day1.find_first_occurrence("321", ["3", "2", "1"])
      "3"
      iex> Day1.find_first_occurrence("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr", ["four", "nine"])
      "four"
      iex> Day1.find_first_occurrence("eightwothree", ["two", "three", "eight"])
      "eight"
  """
  def find_first_occurrence(line, subtexts) do
    Enum.sort(subtexts, fn left, right -> sort_by_position(line, left, right) end)
    |> Enum.at(0)
  end

  @doc """
  Finds the last occurrence of a subtext in a line.

  ## Examples

      iex> Day1.find_last_occurrence("123", [1, 2, 3])
      3
      iex> Day1.find_last_occurrence("213", [1, 2, 3])
      3
      iex> Day1.find_last_occurrence("321", [3, 2, 1])
      1
      iex> Day1.find_last_occurrence("fournine6nine", ["four", 6, "nine"])
      "nine"
      iex> Day1.find_last_occurrence("eightwothree", ["two", "three", "eight"])
      "three"
  """
  def find_last_occurrence(line, subtexts) do
    Enum.sort(subtexts, fn left, right -> last_index_of(line, left) > last_index_of(line, right) end)
    |> Enum.at(0)
  end

  @doc """
  Sorts two strings by their position in a line.

  ## Examples

      iex> Day1.sort_by_position("123", 1, 2)
      true
      iex> Day1.sort_by_position("123", 2, 1)
      false
      iex> Day1.sort_by_position("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr", "four", 6)
      true
      iex> Day1.sort_by_position("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr", "nine", "four")
      false
      iex> Day1.sort_by_position("eightwothree", "two", "eight")
      false
      iex> Day1.sort_by_position("eightwothree", "eight", "two")
      true
  """
  def sort_by_position(line, left, right) do
    first_index_of(line, to_string(left)) < first_index_of(line, to_string(right))
  end

  @doc """
  Finds the index of a subtext in a line.

  ## Examples

      iex> Day1.first_index_of("123", "1")
      0
      iex> Day1.first_index_of("123", "2")
      1
      iex> Day1.first_index_of("123", "3")
      2
      iex> Day1.first_index_of("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr", "four")
      0
      iex> Day1.first_index_of("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr", "nine")
      15
      iex> Day1.first_index_of("eightwothree", "two")
      4
      iex> Day1.first_index_of("eightwothree", "eight")
      0
  """
  def first_index_of(line, subtext) do
    case String.split(line, subtext, parts: 2) do
      [left, _] -> String.length(left)
      _ -> 0
    end
  end

  @doc """
  Finds the last index of a subtext in a line.

  ## Examples

      iex> Day1.last_index_of("123", 1)
      0
      iex> Day1.last_index_of("122", 2)
      2
      iex> Day1.last_index_of("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr", "four")
      0
      iex> Day1.last_index_of("fournine6nine", "nine")
      9
  """
  def last_index_of(line, subtext) do
    case String.split(line, to_string(subtext), parts: 2) do
      [left, right] ->
        case String.contains?(right, to_string(subtext)) do
          true -> String.length(left) + last_index_of(right, subtext) + String.length(to_string(subtext))
          false -> String.length(left)
        end
      _ -> 0
    end
  end

  @doc """
  Combines two digits into a single integer.

  ## Examples

      iex> Day1.combine_digits(1, 2)
      12
      iex> Day1.combine_digits(2, 1)
      21
      iex> Day1.combine_digits("four", "nine")
      49
      iex> Day1.combine_digits("nine", "four")
      94
      iex> Day1.combine_digits("four", 6)
      46
  """
  def combine_digits(left, right) do
    String.to_integer(parse_digit(left) <> parse_digit(right))
  end

  @doc """
  Parses a digit into a string.

  ## Examples

      iex> Day1.parse_digit(1)
      "1"
      iex> Day1.parse_digit(2)
      "2"
      iex> Day1.parse_digit("four")
      "4"
      iex> Day1.parse_digit("nine")
      "9"
      iex> Day1.parse_digit(6)
      "6"
  """
  def parse_digit(digit) when is_integer(digit) do
    to_string(digit)
  end

  def parse_digit(digit) do
    digit_text()[digit] |> to_string()
  end
end
