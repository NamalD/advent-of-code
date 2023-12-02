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
  """
  def find_calibration_value(line) do
    digits = all_digits(line)
    first_digit = Enum.at(digits, 0) |> to_string()
    last_digit = Enum.at(digits, length(digits) - 1) |> to_string()
    String.to_integer(first_digit <> last_digit)
  end

  @doc """
  Finds all digits in a string of alphanumeric characters.
  Textual representations of digits are supported.

  ## Examples
      iex> Day1.all_digits("1")
      [1]
      iex> Day1.all_digits("123")
      [1, 2, 3]
      iex> Day1.all_digits("eightwothree")
      [8, 2, 3]
      iex> Day1.all_digits("123")
      [1, 2, 3]
      iex> Day1.all_digits("abc123")
      [1, 2, 3]
      iex> Day1.all_digits("a1b")
      [1]
      iex> Day1.all_digits("one2")
      [1, 2]
      iex> Day1.all_digits("four2tszbgmxpbvninebxns6nineqbqzgjpmpqr")
      [4, 2, 9, 6, 9]
  """
  def all_digits(text) do
    # TODO: Look at Enum.chunk_while function (https://hexdocs.pm/elixir/1.16/Enum.html#chunk_while/4)

  end

  defp convert_to_digit(word) when word in ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"], do:
    digit_text()[word]
  defp convert_to_digit(digit) when digit in ["1", "2", "3", "4", "5", "6", "7", "8", "9"], do:
    String.to_integer(digit)
end
