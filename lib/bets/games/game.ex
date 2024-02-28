defmodule Bets.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :name, :string
    field :status, :string
    field :game_time, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name, :game_time, :status])
    |> validate_required([:name, :game_time, :status])
    |> unique_constraint(:name)
  end
end
