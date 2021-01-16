defmodule App.Stats.Rushing.ConfigMap do
  @moduledoc """
  Handles configuration and convenience functions
  for Rushing Statistics data.
  """

  @doc """
  Map database columns to Titles and field values.
  Keyword list because Maps order by key value.
  """
  @spec list() :: list()
  def list do
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

  def list_keys, do: Keyword.keys(list())
  def list_values, do: Keyword.values(list())
end
