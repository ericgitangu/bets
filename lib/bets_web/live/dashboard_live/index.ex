defmodule BetsWeb.DashboardLive.Index do
  use BetsWeb, :live_view

  alias Bets.Dashboards
  alias Bets.Dashboards.Dashboard
  alias Bets.Games
  alias Bets.Games.Game
  alias BetsWeb.BetModalComponent


  @impl true
  def render(assigns) do
    ~L"""
    <div class="dashboard">
      <h1>Dashboard</h1>
      <div class="analytics">
        <%= for game <- Bets.Games.list_games() do %>
          <div class="game">
            <h2><%= game.name %></h2>
            <p>Number of players: <%= game.num_players %></p>
            <p>Revenue: <%= game.revenue %></p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :dashboards, Dashboards.list_dashboards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Dashboard")
    |> assign(:dashboard, Dashboards.get_dashboard!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Dashboard")
    |> assign(:dashboard, %Dashboard{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:current_user, socket)
    |> assign(:page_title, "Listing Dashboards")
    |> assign(:dashboard, nil)
  end

  @impl true
  def handle_info({BetsWeb.DashboardLive.FormComponent, {:saved, dashboard}}, socket) do
    {:noreply, stream_insert(socket, :dashboards, dashboard)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    dashboard = Dashboards.get_dashboard!(id)
    {:ok, _} = Dashboards.delete_dashboard(dashboard)

    {:noreply, stream_delete(socket, :dashboards, dashboard)}
  end
  
  @impl true
  def handle_event("show_bet_modal", %{"id" => game_id}, socket) do
    {:noreply, assign(socket, bet_modal: true, selected_game_id: game_id)}
  end

  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply, BetsWeb.UserAuth.logout(socket)}
  end
  
end
