defmodule App.Stats.Rushing.ConfigMapTest do
  use App.DataCase

  alias App.Stats.Rushing.ConfigMap

  describe "list/0" do
    test "map is accurate" do
      assert ConfigMap.list() ==
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
  end
end
