defmodule Bets.Repo.Migrations.PlayerId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :player_id, references(:players, on_delete: :nothing)
    end
    create index(:users, [:player_id])
  end
end
