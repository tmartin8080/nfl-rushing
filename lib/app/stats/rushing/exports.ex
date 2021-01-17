defmodule App.Stats.Rushing.Exports do
  @moduledoc """
  Generates CSV export files using search filter results.
  """

  alias App.Repo
  alias App.Stats.Rushing.ConfigMap
  alias App.Stats.Rushing.RushingSearch
  alias NimbleCSV.RFC4180, as: CSV

  @default_root_dir "priv/exports"
  @default_filename "rushing-report"
  @default_file_modes [:write, :utf8]

  @doc """
  Streams data from DB into a csv report file.
  """
  @spec generate_csv(map()) :: {:ok, String.t()} | {:error, String.t()}
  def generate_csv(params) do
    RushingSearch.stream(params)
    |> Stream.map(&convert_to_row(&1))
    |> write_to_csv_file()
    |> case do
      {:ok, path} -> {:ok, path}
      _ -> {:error, "Something went wrong writing csv file"}
    end
  end

  defp convert_to_row(stream_row) do
    ConfigMap.list_keys()
    |> Enum.into([], fn column ->
      Map.get(stream_row, column)
    end)
  end

  defp write_to_csv_file(rows_stream) do
    filename = build_filename()
    local_path = Application.app_dir(:app, "#{@default_root_dir}/#{filename}")
    file_modes = @default_file_modes
    output = File.stream!(local_path, file_modes)

    Repo.transaction(fn ->
      [ConfigMap.list_values()]
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
