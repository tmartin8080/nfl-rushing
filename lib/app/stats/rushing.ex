defmodule App.Stats.Rushing do
  @moduledoc """
  Rushing Stats Schema

  * `Player` (Player's name)
  * `Team` (Player's team abbreviation)
  * `Pos` (Player's postion)
  * `Att/G` (Rushing Attempts Per Game Average)
  * `Att` (Rushing Attempts)
  * `Yds` (Total Rushing Yards)
  * `Avg` (Rushing Average Yards Per Attempt)
  * `Yds/G` (Rushing Yards Per Game)
  * `TD` (Total Rushing Touchdowns)
  * `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
  * `1st` (Rushing First Downs)
  * `1st%` (Rushing First Down Percentage)
  * `20+` (Rushing 20+ Yards Each)
  * `40+` (Rushing 40+ Yards Each)
  * `FUM` (Rushing Fumbles)
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "stats_rushing" do
    field :player_name, :string
    field :team, :string
    field :position, :string
    field :attempts, :integer
    field :attempts_per_game_avg, :float
    field :total_yards, :integer
    field :avg_yards_per_attempt, :float
    field :yards_per_game, :float
    field :total_touchdowns, :integer
    # string because "T" denotes a TD
    field :longest, :string
    field :first_downs, :integer
    field :first_down_percentage, :float
    field :twenty_plus_yards, :integer
    field :forty_plus_yards, :integer
    field :fumbles, :integer
  end

  def changeset(stats_rushing, attrs) do
    stats_rushing
    |> cast(attrs, config_map_keys())
    |> validate_required(config_map_keys())
  end

  @doc """
  Map database columns to Titles and field values.
  Keyword list because Maps order by key value.
  """
  def config_map do
    [
      player_name: [abbreviation: "Player", import_filter: nil],
      team: [abbreviation: "Team", import_filter: nil],
      position: [abbreviation: "POS", import_filter: nil],
      attempts: [abbreviation: "Att", import_filter: nil],
      attempts_per_game_avg: [abbreviation: "Att/G", import_filter: nil],
      total_yards: [abbreviation: "Yds", import_filter: nil],
      avg_yards_per_attempt: [abbreviation: "Avg", import_filter: nil],
      yards_per_game: [abbreviation: "Yds/G", import_filter: nil],
      total_touchdowns: [abbreviation: "TD", import_filter: nil],
      longest: [abbreviation: "TD", import_filter: nil],
      first_downs: [abbreviation: "1st", import_filter: nil],
      first_down_percentage: [abbreviation: "1st%", import_filter: nil],
      twenty_plus_yards: [abbreviation: "20%", import_filter: nil],
      forty_plus_yards: [abbreviation: "40%", import_filter: nil],
      fumbles: [abbreviation: "FUM", import_filter: nil]
    ]
  end

  def config_map_keys, do: Keyword.keys(config_map())
  def config_map_values, do: Keyword.values(config_map())
end
