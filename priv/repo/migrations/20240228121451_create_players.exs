defmodule Bets.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :wins, :integer, default: 0
      add :losses, :integer, default: 0
      add :draws, :integer, default: 0
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:players, [:user_id])
  end
end
