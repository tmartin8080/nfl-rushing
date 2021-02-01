defmodule App.Stats.Rushing.RushingSearch do
  @moduledoc """
  Search interface for applying filters for search, pagination, and exports.
  """
  alias App.Repo
  alias App.Stats.Rushing
  import Ecto.Query

  @doc """
  Compose search query based on params as criteria.

  Criteria:
  - `term`: search term entered, filters only player name.
  - `sort`: map with field/direction
  - `page`: for pagination

  Options:
  - `paginate`: boolean, disables pagination.
  """
  def search(criteria \\ %{}, opts \\ []) do
    base_query()
    |> build_query(criteria)
    |> maybe_paginate(criteria, opts)
  end

  @doc """
  Stream data from repo.  No pagination
  """
  @spec stream(map()) :: Stream.t()
  def stream(criteria) do
    base_query()
    |> build_query(criteria)
    |> Repo.stream()
  end

  defp base_query do
    from(s in Rushing)
  end

  defp build_query(query, criteria) do
    Enum.reduce(criteria, query, &compose_query/2)
  end

  defp compose_query({"term", term}, query) do
    query
    |> where([s], ilike(s.player_name, ^"%#{term}%"))
  end

  defp compose_query({"sort", %{"field" => "longest", "direction" => direction}}, query) do
    direction = String.to_atom(direction)

    query
    |> order_by(
      [s],
      {^direction, fragment("substring(?, '^[-0-9]+')::int", s.longest)}
    )
  end

  defp compose_query({"sort", %{"field" => sort_field, "direction" => direction}}, query) do
    direction = String.to_atom(direction)
    sort_field = String.to_atom(sort_field)

    query
    |> order_by([s], {^direction, field(s, ^sort_field)})
  end

  defp compose_query(_, query), do: query

  defp maybe_paginate(query, params, paginate: true) do
    page = Map.get(params, "page", 1)
    Repo.paginate(query, page: page, page_size: 15)
  end

  defp maybe_paginate(query, _, _), do: Repo.all(query)
end
