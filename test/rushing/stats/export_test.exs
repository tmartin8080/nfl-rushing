defmodule Rushing.Stats.ExportTest do
  use Rushing.DataCase
  alias Rushing.Stats.Exports

  describe "generate_csv/1" do
    test "generates file" do
      assert {:ok, path} = Exports.generate_csv(%{})
      assert path =~ ~r/rushing-report/
      assert :ok = File.rm!(path)
    end
  end
end
