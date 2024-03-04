defmodule Bets.Repo.Migrations.AdminId do
  use Ecto.Migration

  def change do  
    alter table(:users) do
        add :admin_id, references(:admins, on_delete: :nothing)
      end
  
    create index(:users, [:admin_id])
  end
end
