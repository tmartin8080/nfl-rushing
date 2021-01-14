defmodule RushingWeb.PageLive do
  @moduledoc """
  Create a web app. This must be able to do the following steps:
  - Create a webpage which displays a table with the contents of rushing.json
  - The user should be able to sort the players by Total Rushing Yards, Longest Rush and Total Rushing Touchdowns
    - Yds (Total Rushing Yards)
    - Lng (Longest Rush -- a T represents a touchdown occurred)
    - TD (Total Rushing Touchdowns)
  - The user should be able to filter by the player's name
  - The user should be able to download the sorted data as a CSV, as well as a filtered subset
  - The system should be able to potentially support larger sets of data on the order of 10k records.
  - Update the section Installation and running this solution in the README file explaining how to run your code
  """
  use RushingWeb, :live_view
  alias Rushing.Data

  @sortable ["Yds", "Lng", "TD"]
  @default_params %{}
  @default_sort_direction "desc"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:sortable, @sortable)
     |> assign(:headings, Data.headings_list())}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:params, params)
     |> assign(:target_direction, target_direction(params))
     |> assign(:data, Data.load_data(params))}
  end

  @impl true
  def handle_event("search", %{"term" => term}, %{assigns: %{params: params}} = socket) do
    updated_params = Map.put(params, "term", term)
    handle_reply(socket, updated_params)
  end

  defp handle_reply(socket, updated_params) do
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
    Routes.page_path(socket, action, Enum.into(extra, socket.assigns.params))
  end
end
