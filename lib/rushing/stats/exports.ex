defmodule Rushing.Stats.Exports do
  @moduledoc """
  Generates CSV export files using search filter results.
  """

  alias NimbleCSV.RFC4180, as: CSV
  alias Rushing.Stats.JSONData, as: Data

  @default_root_dir "priv/exports"
  @default_filename "rushing-report"
  @default_file_modes [:write, :utf8]

  def generate_csv(params) do
    filename = build_filename()
    local_path = Application.app_dir(:rushing, "#{@default_root_dir}/#{filename}")

    file_modes = @default_file_modes
    output = File.stream!(local_path, file_modes)

    data =
      Data.load_data(params, paginate: false)
      |> Enum.map(&convert_to_row(&1))

    [Data.headings_list()]
    |> Stream.concat(data)
    |> CSV.dump_to_stream()
    |> Stream.into(output)
    |> Stream.run()

    {:ok, local_path}
  end

  defp convert_to_row(row) do
    Data.headings_list()
    |> Enum.into([], fn heading -> row[heading] end)
  end

  defp build_filename do
    today = DateTime.utc_now()
    day = Date.to_string(today)
    timestamp = DateTime.to_unix(today)
    "#{@default_filename}-#{day}-#{timestamp}.csv"
  end
end
