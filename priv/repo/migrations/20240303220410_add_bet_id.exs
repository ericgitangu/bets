defmodule Bets.Repo.Migrations.AddBetId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :bet_id, references(:bets, on_delete: :nothing)
    end

    create index(:users, [:bet_id])
  end
end
