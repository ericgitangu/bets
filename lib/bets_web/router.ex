defmodule BetsWeb.Router do
  use BetsWeb, :router

  import BetsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BetsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug Bets.Plugs.Authenticate
    plug :put_user_token
    plug Bets.Plugs.SuperUser

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # OAuth2 endpoints
  scope "/auth", BetsWeb do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback_phase
    delete "/logout", AuthController, :logout
  end

  # Routes for frontend users
  scope "/frontendusers", BetsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/new", FrontendUserLive.Index, :new
    live "/:id/update", FrontendUserLive.Index, :update
    live "/:id/edit", FrontendUserLive.Index, :edit
    live "/:id/show", FrontendUserLive.Index, :show
    live "/show/:id", FrontendUserLive.Index, :show
    live "/", FrontendUserLive.Index, :index
  end

  scope "/", BetsWeb do
    pipe_through :browser
     live "/", GameLive.Index, :index
  end

  scope "/games", BetsWeb do
    pipe_through [:browser, :require_super_user]

    live "/new", GameLive.Index, :new
    live "/:id/edit", GameLive.Index, :edit

    live "/:id", GameLive.Show, :show
    live "/:id/show/edit", GameLive.Show, :edit
  end

  # Routes for admins
  scope "/admins", BetsWeb do
    pipe_through [:browser, :require_super_user]

    live "/new", AdminLive.Index, :new
    live "/:id/edit", AdminLive, :edit
    live "/:id/show", AdminLive, :show
    live "/:id/update", AdminLive, :update
    live "/create", AdminLive, :create
    live "/", AdminLive.Index, :index
    live "/show/:id", AdminLive, :show
  end

  scope "/", BetsWeb do
    pipe_through :browser

    # get "/", PageController, :home

    # resources "/games", GameController
    resources "/bets", BetController
    resources "/players", PlayerController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BetsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bets, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BetsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BetsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BetsWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", BetsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BetsWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", BetsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{BetsWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  defp put_user_token(conn, _) do
    token = get_session(conn, :token)
    if conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", conn.assigns.current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  defp require_super_user(conn, _) do
    if conn.assigns[:superuser] do
      conn
    else
      conn
      |> put_flash(:error, "Contact an administrator for access.")
      |> redirect(to: "/users/log_in")
    end
  end
end
