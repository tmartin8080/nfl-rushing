defmodule App.StatsTest do
  use App.DataCase

  alias App.Stats

  describe "stats_rushing" do
    alias App.Stats.Rushing

    @valid_attrs %{
      attempts: 42,
      player_name: "some player_name",
      position: "some position",
      team: "some team"
    }
    @update_attrs %{
      attempts: 43,
      player_name: "some updated player_name",
      position: "some updated position",
      team: "some updated team"
    }
    @invalid_attrs %{attempts: nil, player_name: nil, position: nil, team: nil}

    def rushing_fixture(attrs \\ %{}) do
      {:ok, rushing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_rushing()

      rushing
    end

    test "list_stats_rushing/0 returns all stats_rushing" do
      rushing = rushing_fixture()
      assert Stats.list_stats_rushing() == [rushing]
    end

    test "get_rushing!/1 returns the rushing with given id" do
      rushing = rushing_fixture()
      assert Stats.get_rushing!(rushing.id) == rushing
    end

    test "create_rushing/1 with valid data creates a rushing" do
      assert {:ok, %Rushing{} = rushing} = Stats.create_rushing(@valid_attrs)
      assert rushing.attempts == 42
      assert rushing.player_name == "some player_name"
      assert rushing.position == "some position"
      assert rushing.team == "some team"
    end

    test "create_rushing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_rushing(@invalid_attrs)
    end

    test "update_rushing/2 with valid data updates the rushing" do
      rushing = rushing_fixture()
      assert {:ok, %Rushing{} = rushing} = Stats.update_rushing(rushing, @update_attrs)
      assert rushing.attempts == 43
      assert rushing.player_name == "some updated player_name"
      assert rushing.position == "some updated position"
      assert rushing.team == "some updated team"
    end

    test "update_rushing/2 with invalid data returns error changeset" do
      rushing = rushing_fixture()
      assert {:error, %Ecto.Changeset{}} = Stats.update_rushing(rushing, @invalid_attrs)
      assert rushing == Stats.get_rushing!(rushing.id)
    end

    test "delete_rushing/1 deletes the rushing" do
      rushing = rushing_fixture()
      assert {:ok, %Rushing{}} = Stats.delete_rushing(rushing)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_rushing!(rushing.id) end
    end

    test "change_rushing/1 returns a rushing changeset" do
      rushing = rushing_fixture()
      assert %Ecto.Changeset{} = Stats.change_rushing(rushing)
    end
  end
end
