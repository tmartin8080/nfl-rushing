defmodule App.System.DataHelper do
  @moduledoc """
  System Data Processing Helper.
  """

  def integer_to_float(value), do: value / 1

  def binary_to_integer(value) do
    value
    |> String.replace(",", "")
    |> String.to_integer()
  end
end
