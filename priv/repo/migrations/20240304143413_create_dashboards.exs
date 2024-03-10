defmodule Bets.Repo.Migrations.CreateDashboards do
  use Ecto.Migration

  def change do
    create table(:dashboards) do
      add :amount, :decimal
      add :upcoming_games, :string
      add :past_games, :string
      add :past_games_winner, :string
      add :count_down, :string
      add :game_genre, :string, default: "football"
      add :user_id, references(:users, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)
      add :player_id, references(:players, on_delete: :nothing)
      add :bet_id, references(:bets, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:dashboards, [:user_id])
    create index(:dashboards, [:game_id])
    create index(:dashboards, [:player_id])
    create index(:dashboards, [:bet_id])
  end
end
