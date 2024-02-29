defmodule Bets.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string, unique: true
      add :msisdn, :string, unique: true
      add :role, :string, default: "player"
      add :encrypted_password, :string

      timestamps()
    end

    create index(:players, [:email])
  end
end
