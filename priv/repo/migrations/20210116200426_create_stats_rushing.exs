defmodule App.Repo.Migrations.CreateStatsRushing do
  use Ecto.Migration

  def change do
    create table(:stats_rushing) do
      add :player_name, :string
      add :team, :string
      add :position, :string
      add :attempts, :integer, default: 0
      add :attempts_per_game_avg, :float, default: 0.0
      add :total_yards, :integer, default: 0
      add :avg_yards_per_attempt, :float, default: 0.0
      add :yards_per_game, :float, default: 0.0
      add :total_touchdowns, :integer, default: 0
      add :longest, :string
      add :first_downs, :integer, default: 0
      add :first_down_percentage, :float, default: 0.0
      add :twenty_plus_yards, :integer, default: 0
      add :forty_plus_yards, :integer, default: 0
      add :fumbles, :integer, default: 0
    end

    create index(:stats_rushing, :player_name)
    create index(:stats_rushing, :total_yards)
    create index(:stats_rushing, :longest)
    create index(:stats_rushing, :total_touchdowns)
  end
end
