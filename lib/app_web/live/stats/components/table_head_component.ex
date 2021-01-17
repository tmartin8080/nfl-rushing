defmodule AppWeb.Stats.Rushing.TableHeadComponent do
  @moduledoc """
  Component for handling table head functions for sorting
  """
  use AppWeb, :live_component
  @sortable ["Yds", "Lng", "TD"]
  @default_sort_direction "desc"

  alias App.Stats.Rushing.ConfigMap

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:headings, ConfigMap.list())
     |> assign(:sortable, @sortable)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:params, assigns.params)
     |> assign(:target_direction, target_direction(assigns.params))}
  end

  defp target_direction(%{"sort" => %{"direction" => dir}}) do
    case dir do
      "desc" -> "asc"
      "asc" -> "desc"
      _ -> @default_sort_direction
    end
  end

  defp target_direction(_), do: @default_sort_direction
end
