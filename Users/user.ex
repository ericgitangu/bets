defmodule Bets.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :msisdn, :string
    field :role, Ecto.Enum, values: [:frontend, :admin, :superuser], default: :frontend
    field :encrypted_password, :string

  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :msisdn, :role])
    |> validate_required([:first_name, :last_name, :email, :msisdn, :role])
    |> unique_constraint(:email)
  end
end
