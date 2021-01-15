defmodule Rushing.Stats.Exports do
  @moduledoc """
  Generates CSV export files using search filter results.
  """

  alias NimbleCSV.RFC4180, as: CSV
  alias Rushing.Repo
  alias Rushing.Stats.Data
  alias Rushing.Stats.DataSearch

  @default_root_dir "priv/exports"
  @default_filename "rushing-report"
  @default_file_modes [:write, :utf8]

  @doc """
  Streams data from DB into a csv report file.
  """
  @spec generate_csv(map()) :: {:ok, String.t()} | {:error, String.t()}
  def generate_csv(params) do
    DataSearch.stream(params)
    |> Stream.map(&convert_to_row(&1))
    |> write_to_csv_file()
    |> case do
      {:ok, path} -> {:ok, path}
      _ -> {:error, "Something went wrong writing csv file"}
    end
  end

  defp convert_to_row(stream_row) do
    Data.abbreviation_map_keys()
    |> Enum.into([], fn column ->
      Map.get(stream_row, column)
    end)
  end

  defp write_to_csv_file(rows_stream) do
    filename = build_filename()
    local_path = Application.app_dir(:rushing, "#{@default_root_dir}/#{filename}")
    file_modes = @default_file_modes
    output = File.stream!(local_path, file_modes)

    Repo.transaction(fn ->
      [Data.abbreviation_map_values()]
      |> Stream.concat(rows_stream)
      |> CSV.dump_to_stream()
      |> Stream.into(output)
      |> Stream.run()
    end)

    {:ok, local_path}
  end

  defp build_filename do
    today = DateTime.utc_now()
    day = Date.to_string(today)
    timestamp = DateTime.to_unix(today)
    "#{@default_filename}-#{day}-#{timestamp}.csv"
  end
end
