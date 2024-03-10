defmodule Bets.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        game_time: ~N[2024-03-03 13:53:00],
        name: "some name",
        status: :upcoming,
        user_id: 42
      })
      |> Bets.Games.create_game()

    game
  end
end
