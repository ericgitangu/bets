defmodule Bets.Plugs.Authenticate do
  import Plug.Conn
  use BetsWeb, :controller

  alias Bets.Accounts.User
  alias Bets.Repo

  def init(opts), do: opts

  def call(conn, opts) do
  current_user = get_session(conn, :current_user)
  token = get_session(conn, :token)
  cond do
    current_user ->
    user = Repo.get_by(User, email: current_user.email)
      assign(conn, :token, token)
      assign(conn, :user, user)
      assign(conn, :current_user, user)
    true ->
      assign(conn, :current_user, nil)
    end
  end
end
