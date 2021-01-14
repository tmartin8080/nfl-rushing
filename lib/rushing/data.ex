defmodule Rushing.Data do
  @moduledoc """
  Responsible for loading and filtering data from rushing.json
  """

  alias Rushing.Stats.SortFields

  @path "rushing.json"
  @search_column "Player"
  @headings [
    "Player",
    "Team",
    "Pos",
    "Att",
    "Att/G",
    "Yds",
    "Avg",
    "Yds/G",
    "TD",
    "Lng",
    "1st",
    "1st%",
    "20+",
    "40+",
    "FUM"
  ]
  @default_sort_direction "desc"

  defguard is_search_and_sort(term, field)
           when is_binary(term) and term != "" and is_binary(field) and field != ""

  defguard is_search(term) when is_binary(term) and term != ""
  defguard is_sort(field) when is_binary(field) and field != ""

  @doc """
  Main data handling function.
  """
  @spec load_data(map()) :: list()
  def load_data(params) do
    @path
    |> read_file!()
    |> Jason.decode()
    |> case do
      {:ok, data} ->
        apply_filters(data, params)

      {:error, msg} ->
        raise "Error reading file: #{msg}"
    end
  end

  def headings_list do
    @headings
  end

  defp apply_filters(data, %{"term" => term, "sort" => %{"field" => field}} = params)
       when is_search_and_sort(term, field) do
    data
    |> apply_search_filter(term)
    |> apply_sort_filter(params["sort"])
  end

  defp apply_filters(data, %{"term" => term}) when is_search(term) do
    apply_search_filter(data, term)
  end

  defp apply_filters(data, %{"sort" => %{"field" => field} = sort})
       when is_sort(field) do
    apply_sort_filter(data, sort)
  end

  defp apply_filters(data, _filters) do
    data
  end

  defp apply_search_filter(data, term) do
    Enum.filter(data, fn row ->
      row[@search_column] =~ ~r/#{term}/i
    end)
  end

  defp apply_sort_filter(data, %{"field" => field, "direction" => direction}) do
    direction = parse_direction(direction)
    Enum.sort_by(data, &SortFields.handle_sort(&1, field), String.to_atom(direction))
  end

  defp parse_direction(dir) when is_nil(dir) or dir == "", do: @default_sort_direction
  defp parse_direction(dir), do: dir

  defp read_file!(path) do
    case File.read(path) do
      {:ok, str} -> str
      {:error, _} -> raise "File not found: #{path}"
    end
  end
end
