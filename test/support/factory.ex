defmodule Rushing.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Rushing.Repo

  alias Rushing.Stats.Schema.RushingStats

  def rushing_stat_factory do
    %RushingStats{
      player_name: "Jon Smith",
      team: "JAX",
      position: "RB",
      attempts: 100,
      attempts_per_game_avg: 1.5,
      total_yards: 1000,
      avg_yards_per_attempt: 10.5,
      yards_per_game: 100,
      total_touchdowns: 100,
      longest: "100T",
      first_downs: 10,
      first_down_percentage: 1.5,
      twenty_plus_yards: 100,
      forty_plus_yards: 100,
      fumbles: 10
    }
  end
end
