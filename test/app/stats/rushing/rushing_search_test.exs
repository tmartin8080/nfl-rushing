defmodule App.Stats.Rushing.RushingSearchTest do
  use App.DataCase
  alias App.Stats.Rushing.ConfigMap
  alias App.Stats.Rushing.RushingSearch

  describe "search/1" do
    test "no filters returns results" do
      stat = insert(:stats_rushing)
      assert RushingSearch.search() == [stat]
    end

    test "search filter" do
      stat1 = insert(:stats_rushing, player_name: "xxx xxx")
      insert(:stats_rushing, player_name: "ooo ooo")
      assert RushingSearch.search(search_params("xxx")) == [stat1]
    end

    test "sort by Yds (Total Rushing Yards)" do
      column = ConfigMap.get_key_for_value("Yds")
      stat1 = insert(:stats_rushing, %{column => 1})
      stat2 = insert(:stats_rushing, %{column => -1})
      assert RushingSearch.search(sort_params(column, "desc")) == [stat1, stat2]
      assert RushingSearch.search(sort_params(column, "asc")) == [stat2, stat1]
    end

    test "sort by Lng (Longest Rush -- a T represents a touchdown occurred)" do
      column = ConfigMap.get_key_for_value("Lng")
      stat1 = insert(:stats_rushing, %{column => "85T"})
      stat2 = insert(:stats_rushing, %{column => "99"})
      stat3 = insert(:stats_rushing, %{column => "5"})
      assert RushingSearch.search(sort_params(column, "desc")) == [stat2, stat1, stat3]
      assert RushingSearch.search(sort_params(column, "asc")) == [stat3, stat1, stat2]
    end

    test "sort by TD (Total Rushing Touchdowns)" do
      column = ConfigMap.get_key_for_value("TD")
      stat1 = insert(:stats_rushing, %{column => "100"})
      stat2 = insert(:stats_rushing, %{column => 5})
      assert RushingSearch.search(sort_params(column, "desc")) == [stat1, stat2]
      assert RushingSearch.search(sort_params(column, "asc")) == [stat2, stat1]
    end

    test "search and sort work together" do
      column = ConfigMap.get_key_for_value("TD")
      stat1 = insert(:stats_rushing, %{column => 100, player_name: "xxx xxx"})
      _stat2 = insert(:stats_rushing, %{column => 6})
      stat3 = insert(:stats_rushing, %{column => 82, player_name: "xxx xxx"})
      _stat4 = insert(:stats_rushing, %{column => 9})

      assert RushingSearch.search(search_and_sort_params("xxx", column, "desc")) == [stat1, stat3]
      assert RushingSearch.search(search_and_sort_params("xxx", column, "asc")) == [stat3, stat1]
    end
  end

  defp sort_params(column, direction) do
    %{
      "sort" => %{
        "field" => Atom.to_string(column),
        "direction" => direction
      }
    }
  end

  defp search_params(term) do
    %{"term" => term}
  end

  defp search_and_sort_params(term, column, direction) do
    search_params(term)
    |> Map.merge(sort_params(column, direction))
  end
end
