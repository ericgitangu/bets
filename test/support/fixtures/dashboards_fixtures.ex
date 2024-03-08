defmodule Bets.DashboardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Dashboards` context.
  """

  @doc """
  Generate a dashboard.
  """
  def dashboard_fixture(attrs \\ %{}) do
    {:ok, dashboard} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        count_down: "some count_down",
        game_genre: :football,
        past_games: "some past_games",
        past_games_winner: "some past_games_winner",
        upcoming_games: "some upcoming_games"
      })
      |> Bets.Dashboards.create_dashboard()

    dashboard
  end
end
