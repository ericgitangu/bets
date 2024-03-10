defmodule BetsWeb.AuthController do
  use Phoenix.Controller
  plug Ueberauth
  require Logger

  alias Bets.Accounts.User

  def callback_phase(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed: #{fails.reason}")
    |> redirect(to: "/")
  end

  def callback_phase(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    token = auth.credentials.token
    name = auth.info.name
    user_creation_result = User.get_or_create_user(auth.info)
    assign_current_user(conn, token)

    case user_creation_result do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back #{name}!")
        |> assign(:current_user, auth.info)
        |> put_session(:current_user, auth.info)
        |> put_session(:token, token)
        |> put_session("authorization", "Token Bearer: #{token}")
        |> redirect(to: "/")

        Logger.info(
          "User created successfully with token: #{token} and name: #{name}! User: #{inspect(user)}"
        )

      {:error, reason} when reason == "User already exists!" ->
        conn
        |> put_flash(:info, "Welcome back #{name}!")
        |> assign(:current_user, auth.info)
        |> put_session(:current_user, auth.info)
        |> put_session(:token, token)
        |> put_session("authorization", "Token Bearer: #{token}")
        |> redirect(to: "/")

        Logger.info("User already exists with token: " <> token <> " and name: " <> name <> "!")

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

  defp assign_current_user(conn, user) do
    conn
    |> assign(:current_user, user)
  end
end
