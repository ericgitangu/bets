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
        name: "some name",
        status: "some status",
        type: "some type"
      })
      |> Bets.Games.create_game()

    game
  end

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Bets.Games.create_game()

    game
  end
end
