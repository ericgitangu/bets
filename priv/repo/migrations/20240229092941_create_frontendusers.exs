defmodule Bets.Repo.Migrations.CreateFrontendusers do
  use Ecto.Migration

  def change do
    create table(:frontendusers) do
      add :name, :string
      add :role, :string, default: "user"
      add :confirmed_at, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)
      add :bet_id, references(:bets, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
    create index(:frontendusers, [:user_id])
    create index(:frontendusers, [:game_id])
    create index(:frontendusers, [:bet_id])
  end
end
