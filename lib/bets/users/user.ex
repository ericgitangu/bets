defmodule Bets.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email_address, :string
    field :encrypted_password, :string
    field :msisdn, :string
    field :role, Ecto.Enum, values: [:user, :admin, :superuser], default: :user

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email_address, :encrypted_password, :msisdn, :role])
    |> validate_required([:first_name, :last_name, :email_address, :encrypted_password, :msisdn, :role])
    |> unique_constraint(:email_address)
  end
end
