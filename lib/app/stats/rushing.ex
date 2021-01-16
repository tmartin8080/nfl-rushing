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
    |> cast(attrs, abbreviation_map_keys())
    |> validate_required(abbreviation_map_keys())
  end

  @doc """
  Map database columns to Titles and field values.
  Keyword list because Maps order by key value.
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
end
