defmodule Bets.Repo.Migrations.AddGameId do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :game_id, references(:games, on_delete: :nothing)
    end

    create index(:users, [:game_id])

  end
end
