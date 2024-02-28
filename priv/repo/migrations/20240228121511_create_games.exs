# priv/repo/migrations/TIMESTAMP_create_games.exs
defmodule Bets.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :game_time, :naive_datetime
      add :status, :string, default: "upcoming"

      timestamps()
    end
  end
end
