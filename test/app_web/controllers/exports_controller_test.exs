defmodule AppWeb.ExportsControllerTest do
  use AppWeb.ConnCase

  test "POST /exports", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
