defmodule Bets.Repo do
  use Ecto.Repo,
    otp_app: :bets,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
