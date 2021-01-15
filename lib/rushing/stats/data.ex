defmodule Rushing.Stats.Data do
  @moduledoc """
  Rushing Stats Data Context
  """

  import Ecto.Query, warn: false
  alias Rushing.Stats.DataSearch

  @default_page_size 15

  def load_data(params \\ %{}, opts \\ []) do
    DataSearch.search(params)
    |> maybe_paginate(params, opts)
  end

  @doc """
  Map database columns to Titles and field values.
  Keyword list because Maps order by key value
  """
  def abbreviation_map do
    [
      player_name: "Player",
      team: "Team",
      position: "Pos",
      attempts: "Att",
      attempts_per_game_avg: "Att/G",
      total_yards: "Yds",
      avg_yards_per_attempt: "Avg",
      yards_per_game: "Yds/G",
      total_touchdowns: "TD",
      longest: "Lng",
      first_downs: "1st",
      first_down_percentage: "1st%",
      twenty_plus_yards: "20+",
      forty_plus_yards: "40+",
      fumbles: "FUM"
    ]
  end

  def abbreviation_map_keys, do: Keyword.keys(abbreviation_map())
  def abbreviation_map_values, do: Keyword.values(abbreviation_map())

  def integer_to_float(value), do: value / 1

  def binary_to_integer(value) do
    value
    |> String.replace(",", "")
    |> String.to_integer()
  end

  defp maybe_paginate(data, _, paginate: false), do: data

  defp maybe_paginate(data, params, _) do
    config = maybe_put_default_config(params)

    data
    |> Scrivener.paginate(config)
  end

  defp maybe_put_default_config(%{"page" => _page_number} = params) do
    Map.put(params, "page_size", @default_page_size)
  end

  defp maybe_put_default_config(_params) do
    %Scrivener.Config{page_number: 1, page_size: @default_page_size}
  end
end
