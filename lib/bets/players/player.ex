defmodule Bets.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :msisdn, :string
    field :role, Ecto.Enum, values: [:user, :admin, :superuser], default: :user

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:first_name, :last_name, :email, :encrypted_password, :msisdn, :role])
    |> validate_required([:first_name, :last_name, :email,:role])
  end
end
