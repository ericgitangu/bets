defmodule Bets.Admins.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field :name, :string
    field :user_id, :integer
    field :frontend_user_id, :integer
    field :game_id, :integer
    field :bet_id, :integer
    field :admin_id, :integer

    has_many :games, Bets.Games.Game
    has_many :frontend_users, Bets.FrontendUsers.FrontendUser
    has_many :bets, Bets.Wagers.Bet
    has_many :user, Bets.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:name, :user_id, :frontend_user_id, :game_id, :bet_id])
    |> validate_required([:name])
  end
end
