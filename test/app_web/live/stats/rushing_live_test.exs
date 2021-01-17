defmodule AppWeb.Stats.RushingLiveTest do
  use AppWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Rushing Statistics"
    assert render(page_live) =~ "Rushing Statistics"
  end

  test "search filter", %{conn: conn} do
    stat1 = insert(:stats_rushing, player_name: "Dog Jones")
    stat2 = insert(:stats_rushing, player_name: "Doug Smith")

    {:ok, page_live, _html} = live(conn, "/")
    html = render_change(page_live, :search, %{term: "dog"})
    assert html =~ stat1.player_name
    refute html =~ stat2.player_name
  end

  test "sort filter", %{conn: conn} do
    stat1 = insert(:stats_rushing, longest: "89T")
    stat2 = insert(:stats_rushing, longest: "94")

    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "tbody tr:first-child td", stat1.player_name)
    assert render_patch(view, "/?sort[field]=longest&sort[direction]=desc")
    assert has_element?(view, "tbody tr:first-child td", stat2.player_name)
  end
end
