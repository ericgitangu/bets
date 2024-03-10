defmodule Bets.Wagers.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :amount, :decimal
    field :outcome, Ecto.Enum, values: [:win, :lost, :draw], default: :lost
    field :player_id, :integer
    field :game_id, :integer
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:amount, :player_id, :game_id, :outcome, :user_id])
    |> validate_required([:amount, :outcome])
  end
end
