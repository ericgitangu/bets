defmodule Bets.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :wins, :integer, default: 0
    field :losses, :integer, default: 0
    field :draws, :integer, default: 0
    field :user_id, :integer
    field :game_id, :integer
    field :bet_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:wins, :losses, :draws, :user_id, :game_id, :bet_id])
    |> validate_required([:wins, :losses, :draws])
    |> unique_constraint(:user_id)
  end
end
