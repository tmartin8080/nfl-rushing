defmodule Mix.Tasks.App.Import.RushingTest do
  use App.DataCase

  alias App.Stats
  alias Mix.Tasks.App.Import.Rushing

  describe "run/1" do
    test "imports data" do
      assert Rushing.run("rushing.json") == :ok
      assert Stats.list_stats_rushing() |> Enum.count() == 326
    end
  end
end
