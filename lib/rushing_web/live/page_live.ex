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

  @default_filters %{
    search: "",
    sort: %{"field" => "", "direction" => "desc"}
  }
  @sortable ["Yds", "Lng", "TD"]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:sortable, @sortable)
     |> assign(:filters, @default_filters)
     |> assign(:data, Data.load_data(@default_filters))
     |> assign(:headings, Data.headings_list())}
  end

  @impl true
  def handle_event("search", %{"term" => term}, %{assigns: %{filters: filters}} = socket) do
    updated_filters = Map.replace!(filters, :search, term)
    handle_reply(socket, updated_filters)
  end

  @impl true
  def handle_event("sort", params, %{assigns: %{filters: filters}} = socket) do
    updated_filters = Map.replace!(filters, :sort, params)
    handle_reply(socket, updated_filters)
  end

  defp handle_reply(socket, updated_filters) do
    {:noreply, assign(socket, filters: updated_filters, data: Data.load_data(updated_filters))}
  end
end
