defmodule Bets.Plugs.Authenticate do
  import Plug.Conn
  use BetsWeb, :controller

  alias Bets.Players
  alias Bets.Repo

  def init(opts), do: opts

  def call(conn, _opts) do
  user_id = get_session(conn, :current_user)
  cond do
    user_id ->
      user = Repo.get(Players, user_id)
      assign(conn, :user_id, user_id)
      assign(conn, :user, user)
      assign(conn, :current_user, user)
    true ->
      assign(conn, :current_user, nil)
    end
  end
end
