defmodule Bets.FrontendUsers.FrontendUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "frontendusers" do
    field :name, :string
    field :user_id, :integer
    field :admin_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(frontend_user, attrs) do
    frontend_user
    |> cast(attrs, [:name, :user_id, :admin_id])
    |> validate_required([:name])
  end
end
