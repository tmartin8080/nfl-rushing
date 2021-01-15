defmodule Rushing.Repo.Migrations.CreateRushingStats do
  use Ecto.Migration

  def change do
    create table(:rushing_stats) do
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

    create index(:rushing_stats, :player_name)
    create index(:rushing_stats, :total_yards)
    create index(:rushing_stats, :longest)
    create index(:rushing_stats, :total_touchdowns)
  end
end
