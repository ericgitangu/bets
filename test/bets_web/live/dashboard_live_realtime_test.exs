# test/my_app_web/live/dashboard_live_real_time_test.exs

defmodule BetsWeb.DashboardLiveRealTimeTest do
  use BetsWeb.ConnCase

  import Phoenix.LiveViewTest
  alias BetsWeb.Endpoint

  setup do
    {:ok, _, view} = live(conn, "/dashboard")
    {:ok, view: view}
  end

  test "updates games in real-time", %{view: view} do
    # Broadcast a game start event
    game = insert(:game)
    Endpoint.broadcast("games:lobby", "game_started", %{game_id: game.id})
    assert render(view) =~ "Game #{game.id} started"

    # Broadcast a game end event
    winner = insert(:user)
    Endpoint.broadcast("games:lobby", "game_ended", %{game_id: game.id, winner: winner.email})
    assert render(view) =~ "Game #{game.id} ended, winner: #{winner.email}"
  end
end
