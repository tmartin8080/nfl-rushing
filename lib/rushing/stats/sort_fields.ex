defmodule Rushing.Stats.SortFields do
  @moduledoc """
  Cleans field values for sorting.
  Each column is handled differently.
  """

  @doc """
  Multi-clause function for sorting certain fields.
  """
  @spec handle_sort(map(), String.t()) :: String.t() | integer()
  def handle_sort(%{"Yds" => value}, "Yds") when is_binary(value) do
    value
    |> String.replace(",", "")
    |> String.to_integer()
  end

  def handle_sort(%{"Yds" => value}, "Yds") when is_integer(value), do: value

  def handle_sort(%{"TD" => value}, "TD") when is_binary(value) do
    value
    |> String.to_integer()
  end

  def handle_sort(%{"TD" => value}, "TD") when is_integer(value), do: value

  def handle_sort(%{"Lng" => value}, "Lng") when is_binary(value) do
    value
    |> String.replace("T", "")
    |> String.to_integer()
  end

  def handle_sort(%{"Lng" => value}, "Lng") when is_integer(value), do: value

  def handle_sort(row, field), do: row[field]
end
