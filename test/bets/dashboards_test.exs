defmodule Bets.DashboardsTest do
  use Bets.DataCase

  alias Bets.Dashboards

  describe "dashboards" do
    alias Bets.Dashboards.Dashboard

    import Bets.DashboardsFixtures

    @invalid_attrs %{amount: nil, upcoming_games: nil, past_games: nil, past_games_winner: nil, count_down: nil, game_genre: nil}

    test "list_dashboards/0 returns all dashboards" do
      dashboard = dashboard_fixture()
      assert Dashboards.list_dashboards() == [dashboard]
    end

    test "get_dashboard!/1 returns the dashboard with given id" do
      dashboard = dashboard_fixture()
      assert Dashboards.get_dashboard!(dashboard.id) == dashboard
    end

    test "create_dashboard/1 with valid data creates a dashboard" do
      valid_attrs = %{amount: "120.5", upcoming_games: "some upcoming_games", past_games: "some past_games", past_games_winner: "some past_games_winner", count_down: "some count_down", game_genre: :football}

      assert {:ok, %Dashboard{} = dashboard} = Dashboards.create_dashboard(valid_attrs)
      assert dashboard.amount == Decimal.new("120.5")
      assert dashboard.upcoming_games == "some upcoming_games"
      assert dashboard.past_games == "some past_games"
      assert dashboard.past_games_winner == "some past_games_winner"
      assert dashboard.count_down == "some count_down"
      assert dashboard.game_genre == :football
    end

    test "create_dashboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboards.create_dashboard(@invalid_attrs)
    end

    test "update_dashboard/2 with valid data updates the dashboard" do
      dashboard = dashboard_fixture()
      update_attrs = %{amount: "456.7", upcoming_games: "some updated upcoming_games", past_games: "some updated past_games", past_games_winner: "some updated past_games_winner", count_down: "some updated count_down", game_genre: :football}

      assert {:ok, %Dashboard{} = dashboard} = Dashboards.update_dashboard(dashboard, update_attrs)
      assert dashboard.amount == Decimal.new("456.7")
      assert dashboard.upcoming_games == "some updated upcoming_games"
      assert dashboard.past_games == "some updated past_games"
      assert dashboard.past_games_winner == "some updated past_games_winner"
      assert dashboard.count_down == "some updated count_down"
      assert dashboard.game_genre == :football
    end

    test "update_dashboard/2 with invalid data returns error changeset" do
      dashboard = dashboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboards.update_dashboard(dashboard, @invalid_attrs)
      assert dashboard == Dashboards.get_dashboard!(dashboard.id)
    end

    test "delete_dashboard/1 deletes the dashboard" do
      dashboard = dashboard_fixture()
      assert {:ok, %Dashboard{}} = Dashboards.delete_dashboard(dashboard)
      assert_raise Ecto.NoResultsError, fn -> Dashboards.get_dashboard!(dashboard.id) end
    end

    test "change_dashboard/1 returns a dashboard changeset" do
      dashboard = dashboard_fixture()
      assert %Ecto.Changeset{} = Dashboards.change_dashboard(dashboard)
    end
  end
end
