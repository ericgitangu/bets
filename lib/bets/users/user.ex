defmodule Bets.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :name, :string
    field :role, Ecto.Enum, values: [:user, :admin, :superuser], default: :user
    field :email, :string
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime
    field :user_id, :integer
    field :game_id, :integer
    field :bet_id, :integer
    field :player_id, :integer
    field :admin_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :role, :email, :hashed_password, :confirmed_at, :user_id, :game_id, :bet_id, :player_id, :admin_id])
    |> validate_required([:name, :role, :email, :hashed_password, :confirmed_at])
  end
end
