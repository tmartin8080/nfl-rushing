defmodule Mix.Tasks.App.Import.Rushing do
  @moduledoc """
  Imports json data from file by streaming the file
  into chunks which are inserted using `insert_all`
  100 records at a time.

  Usage:
    mix app.import.rushing "rushing.json"
  """
  use Mix.Task
  alias App.Repo
  alias App.Stats.Rushing
  alias App.Stats.Rushing.ConfigMap
  alias App.System.DataHelpers

  require Logger

  @stream_chunk_size 100
  @jaxon_stream_query [:root, :all]

  @shortdoc "Imports stream data from given json file"
  @impl true
  def run(path) do
    Logger.info("Importing data from #{path}...")

    with {:ok, result, _} <-
           Ecto.Migrator.with_repo(Repo, fn repo ->
             import_json_file(repo, path)
           end),
         do: result
  end

  defp import_json_file(repo, path) do
    path
    |> File.stream!()
    |> Jaxon.Stream.from_enumerable()
    |> Jaxon.Stream.query(@jaxon_stream_query)
    |> Stream.chunk_every(@stream_chunk_size)
    |> Stream.map(&process_chunk(&1, repo))
    |> Stream.run()
  end

  defp process_chunk(stream_chunk, repo) do
    stream_chunk
    |> Enum.map(&prepare_insert_all/1)
    |> insert_chunk(repo)
  end

  defp prepare_insert_all(stream_row) do
    Enum.reduce(stream_row, %{}, &translate_source_map_to_insert_map/2)
  end

  defp translate_source_map_to_insert_map({stream_row_key, stream_row_value}, insert_row_map) do
    insert_key = ConfigMap.get_key_for_value(stream_row_key)

    Map.put(insert_row_map, insert_key, prepare_value(insert_key, stream_row_value))
  end

  defp prepare_value(:attempts_per_game_avg, value) when is_integer(value),
    do: DataHelpers.integer_to_float(value)

  defp prepare_value(:first_down_percentage, value) when is_integer(value),
    do: DataHelpers.integer_to_float(value)

  defp prepare_value(:yards_per_game, value) when is_integer(value),
    do: DataHelpers.integer_to_float(value)

  defp prepare_value(:avg_yards_per_attempt, value) when is_integer(value),
    do: DataHelpers.integer_to_float(value)

  defp prepare_value(:total_yards, value) when is_binary(value),
    do: DataHelpers.binary_to_integer(value)

  defp prepare_value(:longest, value) when is_integer(value),
    do: Integer.to_string(value)

  defp prepare_value(:longest, value) when is_binary(value),
    do: value

  defp prepare_value(_, value), do: value

  defp insert_chunk(data, repo) do
    repo.insert_all(Rushing, data)
  end
end
