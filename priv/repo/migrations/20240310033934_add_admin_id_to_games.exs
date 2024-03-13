defmodule Bets.Repo.Migrations.AddAdminId do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :admin_id, references(:users, on_delete: :nothing)
    end
  end
end
