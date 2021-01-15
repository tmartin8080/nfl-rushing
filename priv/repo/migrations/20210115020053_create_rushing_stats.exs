defmodule Rushing.Repo.Migrations.CreateRushingStats do
  @moduledoc """
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
  use Ecto.Migration

  def change do
    create table(:rushing_stats) do
      add :player_name, :string
      add :team, :string
      add :position, :string
      add :attempts, :integer, default: 0
      add :attempts_avg, :float, default: 0.0
      add :yards, :integer, default: 0
      add :yards_avg, :float, default: 0.0
      add :touchdowns, :integer, default: 0
      add :longest, :string
      add :longest_first_down_percentage, :float, default: 0.0
      add :twenty_plus_yards, :integer, default: 0
      add :fourty_plus_yards, :integer, default: 0
      add :fumbles, :integer, default: 0
      timestamps()
    end
  end
end
