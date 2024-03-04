defmodule Bets.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :amount, :decimal
      add :outcome, :string, default: "pending"
      add :player_id, references(:players, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:bets, [:user_id])
    create index(:bets, [:player_id])
    create index(:bets, [:game_id])
  end
end
