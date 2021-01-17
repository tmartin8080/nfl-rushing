defmodule App.Stats.Rushing.ExportsTest do
  use App.DataCase
  alias App.Stats.Rushing.Exports

  describe "generate_csv/1" do
    test "generates file" do
      %{player_name: _player_name} = insert(:stats_rushing, %{player_name: "Ezikiel Something"})
      assert {:ok, path} = Exports.generate_csv(%{})
      assert path =~ ~r/rushing-report/
      assert :ok = File.rm!(path)
    end
  end
end
