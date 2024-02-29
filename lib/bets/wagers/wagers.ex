defmodule Bets.Wagers.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :amount, :decimal
    belongs_to :player, Bets.Players.Player
    belongs_to :game, Bets.Games.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
