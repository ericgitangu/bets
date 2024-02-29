defmodule Bets.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Players` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        email: "some email",
        encrypted_password: "some encrypted_password",
        first_name: "some first_name",
        last_name: "some last_name",
        msisdn: "some msisdn",
        role: :user
      })
      |> Bets.Players.create_player()

    player
  end
end
