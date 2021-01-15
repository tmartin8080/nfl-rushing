defmodule Rushing.Stats.ExportsTest do
  use Rushing.DataCase
  alias Rushing.Stats.Exports

  describe "generate_csv/1" do
    test "generates file" do
      %{player_name: _player_name} = insert(:rushing_stat, %{player_name: "Ezikiel Something"})
      assert {:ok, path} = Exports.generate_csv(%{})
      assert path =~ ~r/rushing-report/
      assert :ok = File.rm!(path)
    end
  end
end
