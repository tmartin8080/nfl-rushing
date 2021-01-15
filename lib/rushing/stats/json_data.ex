defmodule Rushing.Stats.JSONData do
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
  @default_page_size 15

  defguard is_search_and_sort(term, field)
           when is_binary(term) and term != "" and is_binary(field) and field != ""

  defguard is_search(term) when is_binary(term) and term != ""
  defguard is_sort(field) when is_binary(field) and field != ""

  @doc """
  Main data handling function.
  """
  @spec load_data(map(), list()) :: [map()]
  def load_data(params \\ %{}, opts \\ []) do
    Keyword.get(opts, :path, @path)
    |> read_file!()
    |> Jason.decode()
    |> case do
      {:ok, data} ->
        data
        |> apply_filters(params)
        |> maybe_paginate(params, opts)

      {:error, msg} ->
        raise "Error reading file: #{msg}"
    end
  end

  @doc """
  List table and csv headings.
  """
  @spec headings_list() :: [String.t()]
  def headings_list do
    @headings
  end

  defp maybe_paginate(data, _, paginate: false), do: data

  defp maybe_paginate(data, params, _) do
    config = maybe_put_default_config(params)

    data
    |> Scrivener.paginate(config)
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

  defp parse_direction(dir) do
    case Enum.member?(["asc", "desc"], dir) do
      true -> dir
      false -> @default_sort_direction
    end
  end

  defp read_file!(path) do
    case File.read(path) do
      {:ok, str} -> str
      {:error, _} -> raise "File not found: #{path}"
    end
  end

  defp maybe_put_default_config(%{"page" => _page_number} = params) do
    Map.put(params, "page_size", @default_page_size)
  end

  defp maybe_put_default_config(_params) do
    %Scrivener.Config{page_number: 1, page_size: @default_page_size}
  end
end