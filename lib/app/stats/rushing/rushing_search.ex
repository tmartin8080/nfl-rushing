defmodule App.Stats.Rushing.RushingSearch do
  @moduledoc """
  Search for data using filters.
  """
  alias App.Repo
  alias App.Stats.Rushing
  import Ecto.Query

  def search(criteria \\ %{}) do
    base_query()
    |> build_query(criteria)
    |> Repo.all()
  end

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
end
