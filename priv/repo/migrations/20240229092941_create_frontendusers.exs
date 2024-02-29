defmodule Bets.Repo.Migrations.CreateFrontendusers do
  use Ecto.Migration

  def change do
    create table(:frontendusers) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
