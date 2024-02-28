defmodule Bets.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email_address, :string, unique: true
      add :msisdn, :string, unique: true
      add :role, :string, default: "user"
      add :encrypted_password, :string

      timestamps()
    end

    create index(:users, [:email_address])
  end
end
