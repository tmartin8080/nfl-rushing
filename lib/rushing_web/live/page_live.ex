defmodule RushingWeb.PageLive do
  use RushingWeb, :live_view

  @path "rushing.json"
  @default_filters %{search: "", sort: []}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:filters, @default_filters)
     |> assign(:data, load_data(@default_filters))
     |> assign(:headings, headings())}
  end

  @impl true
  def handle_event("search", %{"term" => term}, %{assigns: %{filters: filters}} = socket) do
    updated_filters = Map.replace!(filters, :search, term)
    IO.inspect(updated_filters)
    {:noreply, assign(socket, data: load_data(updated_filters))}
  end

  defp load_data(filters) do
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

  defp apply_filters(data, %{search: term}) when term != "" do
    Enum.filter(data, fn row -> row["Player"] =~ term end)
  end

  defp apply_filters(data, _filters), do: data

  defp read_file!(path) do
    case File.read(path) do
      {:ok, str} -> str
      {:error, _} -> raise "File not found: #{path}"
    end
  end

  defp headings do
    [
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
  end
end
