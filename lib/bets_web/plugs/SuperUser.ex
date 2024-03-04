defmodule Bets.Plugs.SuperUser do
  import Plug.Conn
  use BetsWeb, :controller

  alias Bets.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      %User{role: "superuser"} ->
        conn
      _ ->
        conn
        |> put_flash(:error, "Access denied: Contact an administrator for access.")
        |> redirect(to: "/")
        |> halt()
    end
  end
end
