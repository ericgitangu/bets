defmodule BetsWeb.DashboardLiveTest do
  use BetsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bets.DashboardsFixtures

  @create_attrs %{
    amount: "120.5",
    upcoming_games: "some upcoming_games",
    past_games: "some past_games",
    past_games_winner: "some past_games_winner",
    count_down: "some count_down",
    game_genre: :football
  }
  @update_attrs %{
    amount: "456.7",
    upcoming_games: "some updated upcoming_games",
    past_games: "some updated past_games",
    past_games_winner: "some updated past_games_winner",
    count_down: "some updated count_down",
    game_genre: :football
  }
  @invalid_attrs %{
    amount: nil,
    upcoming_games: nil,
    past_games: nil,
    past_games_winner: nil,
    count_down: nil,
    game_genre: nil
  }

  defp create_dashboard(_) do
    dashboard = dashboard_fixture()
    %{dashboard: dashboard}
  end

  describe "Index" do
    setup [:create_dashboard]

    test "lists all dashboards", %{conn: conn, dashboard: dashboard} do
      {:ok, _index_live, html} = live(conn, ~p"/dashboards")

      assert html =~ "Listing Dashboards"
      assert html =~ dashboard.upcoming_games
    end

    test "saves new dashboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("a", "New Dashboard") |> render_click() =~
               "New Dashboard"

      assert_patch(index_live, ~p"/dashboards/new")

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dashboard-form", dashboard: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard created successfully"
      assert html =~ "some upcoming_games"
    end

    test "updates dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("#dashboards-#{dashboard.id} a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(index_live, ~p"/dashboards/#{dashboard}/edit")

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dashboard-form", dashboard: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard updated successfully"
      assert html =~ "some updated upcoming_games"
    end

    test "deletes dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("#dashboards-#{dashboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#dashboards-#{dashboard.id}")
    end
  end

  describe "Show" do
    setup [:create_dashboard]

    test "displays dashboard", %{conn: conn, dashboard: dashboard} do
      {:ok, _show_live, html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert html =~ "Show Dashboard"
      assert html =~ dashboard.upcoming_games
    end

    test "updates dashboard within modal", %{conn: conn, dashboard: dashboard} do
      {:ok, show_live, _html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(show_live, ~p"/dashboards/ch#{dashboard}/show/edit")

      assert show_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#dashboard-form", dashboard: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/dashboards/#{dashboard}")

      html = render(show_live)
      assert html =~ "Dashboard updated successfully"
      assert html =~ "some updated upcoming_games"
    end

    # Additional tests
    test "renders upcoming and past games", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dashboard")

      # Assuming you have a setup function to insert mock games into your database
      upcoming_games = insert_upcoming_games()
      past_games = insert_past_games()

      assert render(view) =~ "Upcoming Games"

      Enum.each(upcoming_games, fn game ->
        assert render(view) =~ "#{game.name}"
      end)

      assert render(view) =~ "Past Games"

      Enum.each(past_games, fn game ->
        assert render(view) =~ "#{game.name} - Winner: #{game.winner}"
      end)
    end
  end
end
