defmodule BetsWeb.AuthController do
  use Phoenix.Controller
  plug Ueberauth

  alias Bets.Players

  def callback_phase(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed: #{fails.reason}")
    |> redirect(to: "/")
  end

  def callback_phase(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    nickname = auth.info.nickname
    token = auth.credentials.token
    name = auth.info.name
    user_creation_result = Players.get_or_create_user(conn, auth.info)
    IO.inspect(conn, label: "-------------------conn-------------------")

  case user_creation_result do
    {:ok, user} ->
       conn
       |> put_session(:current_user, user)
       |> put_session(:currrent_token, token)
       |> put_session(:user_id, user.id)
       |> put_session(:user, user)
       |> put_session(:ueberauth_auth_info, nickname)
       |> put_flash(:info, "Welcome back #{name}!")
       |> put_session(:user, user)
       |> put_session(:current_user, user.id)
       |> put_session("authorization", "Token Bearer: #{token}")
       |> redirect(to: "/")
    {:error, reason} ->
       conn
       |> put_flash(:error, reason)
       |> redirect(to: "/")
  end
end
# Logs out the user and redirects them to the home page.
  @spec logout(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def logout(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> put_session(:current_user, nil)
    |> delete_resp_cookie("authorization")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def request(conn, %{"provider" => provider}) do
    render(conn, "request.html", callback_url: callback_url(provider, conn))
  end

  def callback_url(_provider, conn) do
    conn
    |> put_flash(:info, "Callback URL")
    |> redirect(to: "/")
  end
end
