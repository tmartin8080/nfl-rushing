defmodule App.System.DataHelpers do
  @moduledoc """
  Prepare values for importing to DB.
  """

  @doc """
  Prepare float values for DB
  """
  @spec integer_to_float(integer()) :: float()
  def integer_to_float(value), do: value / 1

  @doc """
  Prepare integer values for DB.
  Some strings will include commas so also
  removing them.

  Returns negative and non-negative integers.
  """
  @spec binary_to_integer(String.t()) :: integer()
  def binary_to_integer(value) do
    value
    |> String.replace(",", "")
    |> String.to_integer()
  end
end
