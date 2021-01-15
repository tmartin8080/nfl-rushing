defmodule Mix.Tasks.Rushing.Import do
  @moduledoc """
  Imports json data from file.
  Usage:
    mix rushing.import "rushing.json"
  """
  use Mix.Task
  alias Rushing.Repo
  alias Rushing.Stats.RushingStats

  require Logger
  @stream_chunk_size 100

  @shortdoc "Imports data from json file"
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
    |> Jaxon.Stream.query([:root, :all])
    |> Stream.chunk_every(@stream_chunk_size)
    |> Stream.map(&process_chunk(&1, repo))
    |> Stream.run()
  end

  defp process_chunk(stream_chunk, repo) do
    stream_chunk
    |> Enum.map(&prepare_insert/1)
    |> insert_chunk(repo)
  end

  # for every row
  # build a map for insert_all
  defp prepare_insert(stream_row) do
    abbreviation_map = RushingStats.abbreviation_map()

    stream_row
    |> Enum.map(fn {stream_row_key, stream_row_value} ->
      {insert_key, _} =
        Enum.find(abbreviation_map, fn {_key, value} -> value == stream_row_key end)

      {insert_key, prepare_value(insert_key, stream_row_value)}
    end)
    |> Map.new()
  end

  defp prepare_value(:attempts_per_game_avg, value) when is_integer(value),
    do: RushingStats.integer_to_float(value)

  defp prepare_value(:first_down_percentage, value) when is_integer(value),
    do: RushingStats.integer_to_float(value)

  defp prepare_value(:yards_per_game, value) when is_integer(value),
    do: RushingStats.integer_to_float(value)

  defp prepare_value(:avg_yards_per_attempt, value) when is_integer(value),
    do: RushingStats.integer_to_float(value)

  defp prepare_value(:total_yards, value) when is_binary(value),
    do: RushingStats.binary_to_integer(value)

  defp prepare_value(:longest, value) when is_integer(value),
    do: Integer.to_string(value)

  defp prepare_value(:longest, value) when is_binary(value),
    do: value

  defp prepare_value(_, value), do: value

  defp insert_chunk(data, repo) do
    repo.insert_all(RushingStats, data)
  end
end
