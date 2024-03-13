defmodule Bets.Repo.Migrations.CreateSuperUser do
  use Ecto.Migration
  import Ecto.Multi, warn: false

  alias Bets.Repo
  alias Bets.Accounts.User

  def change do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:insert, %User{
      name: "superuser",
      hashed_password: Bcrypt.hash_pwd_salt("sup3rus3r\\/8"),
      email: "superuser@bets.com",
      role: :superuser
    })
    |> Bets.Repo.transaction()
  end
end
