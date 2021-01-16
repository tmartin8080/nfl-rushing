defmodule Mix.Tasks.App.Import.RushingTest do
  use App.DataCase

  alias Mix.Tasks.App.Import.Rushing

  describe "run/1" do
    test "imports data" do
      assert Rushing.run("rushing.json") == :ok
    end
  end
end
