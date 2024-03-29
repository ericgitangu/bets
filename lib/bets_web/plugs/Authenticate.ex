defmodule Bets.Plugs.Authenticate do
  import Plug.Conn
  require Logger
  use BetsWeb, :controller

  alias Bets.Accounts.User
  alias Bets.Repo

  def init(opts), do: opts

  def call(conn, opts) do
    Logger.info("Options: #{inspect(opts)}")
    current_user = get_session(conn, :current_user)
    token = get_session(conn, :token)

    cond do
      current_user != nil ->
        case Repo.get_by(User, email: current_user.email) do
          nil ->
            assign(conn, :current_user, nil)

          # conn

          user ->
            assign(conn, :user_id, user.id)
            assign(conn, :token, token)
            assign(conn, :current_user, user)
            # conn
        end

      true ->
        assign(conn, :current_user, nil)
        conn
    end
  end
end
