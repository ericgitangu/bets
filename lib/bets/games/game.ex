defmodule Bets.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :name, :string
    field :status, Ecto.Enum, values: [:upcoming, :live, :complete], default: :upcoming
    field :game_time, :naive_datetime
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name, :game_time, :status, :user_id])
    |> validate_required([:name, :game_time, :status])
    |> unique_constraint(:name)
  end
end
