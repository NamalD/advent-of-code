defmodule Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """

  def run_part_one do
    File.read!("calibration.txt")
    |> String.split("\n")
    |> Enum.map(fn line -> find_calibration_value(line) end)
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
      iex> Day1.find_calibration_value("abc")
      ** (RuntimeError) No digit found in abc
  """
  def find_calibration_value(line) do
    first = first_digit(line) |> to_string()
    last = last_digit(line) |> to_string()
    String.to_integer(first <> last)
  end

  @doc """
  Finds the first digit in a string of alphanumeric characters.

  ## Examples

      iex> Day1.first_digit("123")
      1
      iex> Day1.first_digit("abc123")
      1
      iex> Day1.first_digit("abc")
      ** (RuntimeError) No digit found in abc
  """
  def first_digit(text) do
    # Try to find the first digit in the string
    [found_digit] = Regex.run(~r/\d/, text)
    String.to_integer(found_digit)
  rescue
    # Raise an error if no digits are found
    _ ->
      raise RuntimeError, "No digit found in #{text}"
  end

  @doc """
  Finds the last digit in a string of alphanumeric characters.

  ## Examples

      iex> Day1.last_digit("123")
      3
      iex> Day1.last_digit("abc123")
      3
      iex> Day1.last_digit("a1b")
      1
      iex> Day1.last_digit("abc")
      ** (RuntimeError) No digit found in abc
  """
  def last_digit(text) do
    String.reverse(text) |> first_digit()
  rescue
    # Raise an error if no digits are found
    _ ->
      raise RuntimeError, "No digit found in #{text}"
  end

end
