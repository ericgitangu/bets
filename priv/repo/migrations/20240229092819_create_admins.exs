defmodule Bets.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string
      add :role, :string, default: "admin"
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
    create index(:admins, [:user_id])
  end
end
