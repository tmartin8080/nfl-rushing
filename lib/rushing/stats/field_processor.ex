defmodule Rushing.Stats.PrepareValues do
  @moduledoc """
  Cleans up field values for sorting etc.
  """

  @doc """
  Multi-clause function for preparing certain fields.
  """
  @spec prepare(map(), String.t()) :: map()
  def prepare(%{"Yds" => value} = row, "Yds") when is_binary(value) do
    new_value =
      value
      |> String.replace(",", "")
      |> String.to_integer()

    Map.replace!(row, "Yds", new_value)
  end

  def prepare(row, _), do: row
end
