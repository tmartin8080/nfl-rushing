defmodule App.System.DataHelpersTest do
  use App.DataCase

  alias App.System.DataHelpers

  describe "integer_to_float/1" do
    test "converts integer to float" do
      assert DataHelpers.integer_to_float(1) == 1.0
    end
  end

  describe "binary_to_integer/1" do
    test "converts string to int" do
      assert DataHelpers.binary_to_integer("1") == 1
    end

    test "removes commas" do
      assert DataHelpers.binary_to_integer("1,000") == 1000
    end
  end
end
