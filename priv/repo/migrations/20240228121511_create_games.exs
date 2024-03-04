# priv/repo/migrations/TIMESTAMP_create_games.exs
defmodule Bets.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :game_time, :naive_datetime
      add :status, :string, default: "upcoming"
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:games, [:user_id])
  end
end
