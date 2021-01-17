defmodule AppWeb.ExportsController do
  use AppWeb, :controller
  alias App.Stats.Rushing.Exports

  def create(conn, params) do
    case Exports.generate_csv(params) do
      {:ok, path} ->
        send_download(conn, {:file, path})

      _ ->
        redirect(conn, to: "/")
    end
  end
end
