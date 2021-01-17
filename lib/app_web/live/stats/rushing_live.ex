defmodule AppWeb.Stats.RushingLive do
  @moduledoc """
  Rushing stats LiveView.
  """
  use AppWeb, :live_view
  import Scrivener.HTML

  alias App.Stats.Rushing.RushingSearch

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:params, params)
     |> assign(:data, RushingSearch.search(params, paginate: true))}
  end

  @impl true
  def handle_event("search", %{"term" => term}, %{assigns: %{params: params}} = socket) do
    updated_params = Map.put(params, "term", term)

    {:noreply,
     socket
     |> push_patch(to: self_path(socket, :index, updated_params))}
  end

  def self_path(socket, action, extra) do
    Routes.rushing_path(socket, action, Enum.into(extra, socket.assigns.params))
  end
end
