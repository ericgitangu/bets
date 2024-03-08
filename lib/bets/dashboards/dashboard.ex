defmodule Bets.Dashboards.Dashboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dashboards" do
    field :amount, :decimal
    field :upcoming_games, :string
    field :past_games, :string
    field :past_games_winner, :string
    field :count_down, :string
    field :game_genre, Ecto.Enum, values: [:football, :other], default: :football
    field :user_id, :integer
    field :game_id, :integer
    field :player_id, :integer
    field :bet_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, [:amount, :upcoming_games, :past_games, :past_games_winner, :count_down, :game_genre, :user_id, :game_id, :player_id, :bet_id])
    |> validate_required([:amount, :upcoming_games, :past_games, :past_games_winner, :count_down, :game_genre])
  end
end
