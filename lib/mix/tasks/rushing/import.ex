defmodule Mix.Tasks.Rushing.Import do
  @moduledoc """
  Imports json data from file.
  Usage:
    mix rushing.import "rushing.json"
  """
  use Mix.Task

  require Logger

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

  defp import_json_file(repo, excluded_codes) do
    # case repo.get_by(Region, name: "US (All)") do
    #   %Region{} ->
    #     Logger.info("Region named 'US (All) already exists, aborting.")
    #     :error

    #   nil ->
    #     country_area_codes =
    #       from(cac in CountryAreaCode)
    #       |> where([cac], cac.country_code == "US")
    #       |> where([cac], cac.code not in ^excluded_codes)
    #       |> repo.all()

    #     multi =
    #       Multi.new()
    #       |> Multi.insert(:region, %Region{name: "US (All)", country_code: "US"})
    #       |> Multi.merge(fn %{region: region} ->
    #         now = Timex.now()

    #         pending_region_area_codes =
    #           Enum.map(country_area_codes, fn cac ->
    #             %{
    #               country_area_code_id: cac.id,
    #               region_id: region.id,
    #               inserted_at: now,
    #               updated_at: now
    #             }
    #           end)

    #         Multi.insert_all(
    #           Multi.new(),
    #           :region_area_codes,
    #           RegionAreaCode,
    #           pending_region_area_codes
    #         )
    #       end)

    #     case Repo.transaction(multi) do
    #       {:error, chset} ->
    #         Logger.error("Failed to create Region: #{chset}")
    #         :error

    #       {:ok, %{region_area_codes: {count, _}}} ->
    #         Logger.info(
    #           "Success! 'US (All)' Region created successfully with #{count} Area Codes"
    #         )

    #         :ok
    #     end
    # end
  end
end
