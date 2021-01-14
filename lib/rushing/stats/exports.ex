defmodule Rushing.Stats.Exports do
  @moduledoc """
  Generates CSV export files using search filter results.
  """

  alias Rushing.Data

  def generate_csv(params) do
    day = Date.utc_today() |> Date.to_string()
    filename = "priv/exports/rushing-report-#{day}-#{:random.uniform(1000)}.csv"
    path = Application.app_dir(:rushing, filename)

    NimbleCSV.define(MyParser, separator: "\t", escape: "\"")

    params
    |> Data.load_data()
    |> Stream.into(File.stream!("large_file.csv"))
    |> Stream.run()

    # |> Enum.into(File.wite(path))

    #   def write_csv_file() do
    # File.write!("users.csv", data_to_csv)
    # end

    # defp data_to_csv() do
    # @user_data
    # end

    {:ok, filename}
  end
end
