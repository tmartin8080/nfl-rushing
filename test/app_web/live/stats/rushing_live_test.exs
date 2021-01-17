defmodule AppWeb.Stats.RushingLiveTest do
  use AppWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Rushing Statistics"
    assert render(page_live) =~ "Rushing Statistics"
  end
end
