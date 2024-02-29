defmodule Bets.FrontendUsers.FrontendUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "frontendusers" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(frontend_user, attrs) do
    frontend_user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
