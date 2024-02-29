defmodule Bets.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
