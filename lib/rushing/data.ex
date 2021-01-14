defmodule Rushing.Data do
  @moduledoc """
  Responsible for loading and filtering data from rushing.json
  """

  alias Rushing.Stats.PrepareValues

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

  @type filters :: %{search: String.t(), sort: map()}

  defguard is_search_and_sort(term, field)
           when is_binary(term) and term != "" and is_binary(field) and field != ""

  defguard is_search(term) when is_binary(term) and term != ""
  defguard is_sort(field) when is_binary(field) and field != ""

  @doc """
  Main data load function.
  """
  @spec load_data(filters()) :: map()
  def load_data(filters) do
    @path
    |> read_file!()
    |> Jason.decode()
    |> case do
      {:ok, data} ->
        apply_filters(data, filters)

      {:error, msg} ->
        raise "Error reading file: #{msg}"
    end
  end

  def headings_list do
    @headings
  end

  # Search and Sort
  defp apply_filters(data, %{search: term, sort: %{"field" => field} = sort})
       when is_search_and_sort(term, field) do
    data
    |> apply_search_filter(term)
    |> apply_sort_filter(sort)
  end

  # Only search
  defp apply_filters(data, %{search: term}) when is_search(term) do
    apply_search_filter(data, term)
  end

  # Only sort
  defp apply_filters(data, %{sort: %{"field" => field} = sort})
       when is_sort(field) do
    apply_sort_filter(data, sort)
  end

  # default
  defp apply_filters(data, _filters) do
    data
  end

  defp apply_search_filter(data, term) do
    Enum.filter(data, fn row ->
      row[@search_column] =~ ~r/#{term}/i
    end)
  end

  defp apply_sort_filter(data, %{"field" => field, "direction" => direction}) do
    data
    |> Enum.map(&PrepareValues.prepare(&1, field))
    |> Enum.sort_by(fn row -> row[field] end, String.to_atom(direction))
  end

  defp read_file!(path) do
    case File.read(path) do
      {:ok, str} -> str
      {:error, _} -> raise "File not found: #{path}"
    end
  end
end
