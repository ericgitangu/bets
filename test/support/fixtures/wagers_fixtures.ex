defmodule Bets.WagersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Wagers` context.
  """

  @doc """
  Generate a bet.
  """
  def bet_fixture(attrs \\ %{}) do
    {:ok, bet} =
      attrs
      |> Enum.into(%{
        amount: "120.5"
      })
      |> Bets.Wagers.create_bet()

    bet
  end
end
