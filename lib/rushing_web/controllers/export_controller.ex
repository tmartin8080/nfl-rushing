defmodule RushingWeb.ExportsController do
  use RushingWeb, :controller
  alias Rushing.Stats.Exports

  def create(conn, params) do
    case Exports.generate_csv(params) do
      {:ok, path} ->
        send_download(conn, {:file, path})

      _ ->
        redirect(conn, to: "/")
    end
  end
end
