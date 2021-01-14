defmodule Rushing.DataTest do
  use Rushing.DataCase
  alias Rushing.Data

  describe "load_data/1" do
    test "loads json data" do
      data = Data.load_data(%{})
      assert Enum.count(data) == 326
    end

    # LV enforces strings keys, so they're
    # also explicitly strings here.
    test "search and sort filter works" do
      data = Data.load_data(%{search: "e", sort: %{"field" => "Yds", "direction" => "desc"}})
      assert %{"Player" => "Ezekiel Elliott"} = Enum.at(data, 0)
    end

    test "search filter works alone" do
      data = Data.load_data(%{search: "Mark Ingram"})
      assert Enum.count(data) == 1
    end

    test "search filter works alone with lowercase" do
      data = Data.load_data(%{search: "mark ingram"})
      assert Enum.count(data) == 1
    end

    test "sort filter works alone" do
      data = Data.load_data(%{sort: %{"field" => "Yds", "direction" => "desc"}})
      assert %{"Player" => "Ezekiel Elliott"} = Enum.at(data, 0)
    end
  end
end
