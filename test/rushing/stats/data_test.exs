defmodule Rushing.Stats.DataTest do
  use Rushing.DataCase
  alias Rushing.Stats.Data

  describe "load_data/1" do
    test "loads paginated data" do
      insert(:rushing_stat)
      data = Data.load_data()
      assert Enum.count(data) == 1
    end

    test "loads unpaginated data" do
      insert(:rushing_stat)
      data = Data.load_data(paginate: false)
      assert Enum.count(data) == 1
    end

    test "search and sort filter works" do
      %{player_name: player_name} = insert(:rushing_stat, %{player_name: "Ezikiel Something"})

      data =
        Data.load_data(%{"term" => "e", "sort" => %{"field" => "longest", "direction" => "desc"}})

      assert %{player_name: ^player_name} = Enum.at(data, 0)
    end

    test "search filter works alone" do
      insert(:rushing_stat, %{player_name: "Mark Ingram"})
      %{entries: data} = Data.load_data(%{"term" => "Mark Ingram"})
      assert Enum.count(data) == 1
    end

    test "search filter works alone with lowercase" do
      insert(:rushing_stat, %{player_name: "Mark Ingram"})
      %{entries: data} = Data.load_data(%{"term" => "mark ingram"})
      assert Enum.count(data) == 1
    end

    test "sort filter works alone" do
      %{player_name: player_name} = insert(:rushing_stat, %{player_name: "Ezikiel Something"})

      %{entries: data} =
        Data.load_data(%{"sort" => %{"field" => "longest", "direction" => "desc"}})

      assert [%{player_name: ^player_name}] = data
    end
  end
end
