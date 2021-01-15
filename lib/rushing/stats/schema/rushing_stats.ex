defmodule Rushing.Stats.Schema.RushingStats do
  @moduledoc """
  Rushing Stats Schema

  ### Challenge Background
  We have sets of records representing football players' rushing statistics. All records have the following attributes:
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
  alias Rushing.Stats.Data

  schema "rushing_stats" do
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

  def import_changeset(rushing_stats, attrs) do
    rushing_stats
    |> cast(attrs, Data.abbreviation_map_keys())
    |> validate_required([:player_name, :team])
  end
end
