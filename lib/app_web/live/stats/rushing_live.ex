defmodule AppWeb.Stats.RushingLive do
  @moduledoc """
  Rushing stats LiveView.
  """
  use AppWeb, :live_view

  alias App.Stats.Rushing.ConfigMap
  alias App.Stats.Rushing.RushingSearch

  @sortable ["Yds", "Lng", "TD"]
  @default_sort_direction "desc"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:sortable, @sortable)
     |> assign(:headings, ConfigMap.list())}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:params, params)
     |> assign(:target_direction, target_direction(params))
     |> assign(:data, RushingSearch.search(params, paginate: true))}
  end

  @impl true
  def handle_event("search", %{"term" => term}, %{assigns: %{params: params}} = socket) do
    updated_params = Map.put(params, "term", term)

    {:noreply,
     socket
     |> assign(:target_direction, target_direction(socket))
     |> push_patch(to: self_path(socket, :index, updated_params))}
  end

  defp target_direction(%{"sort" => %{"direction" => dir}}) do
    case dir do
      "desc" -> "asc"
      "asc" -> "desc"
      _ -> @default_sort_direction
    end
  end

  defp target_direction(_), do: @default_sort_direction

  def self_path(socket, action, extra) do
    Routes.rushing_path(socket, action, Enum.into(extra, socket.assigns.params))
  end
end
