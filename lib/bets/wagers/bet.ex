defmodule Bets.Wagers.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :amount, :decimal
    field :user_id, :id
    field :game_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
