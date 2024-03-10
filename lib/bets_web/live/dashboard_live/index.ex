defmodule BetsWeb.DashboardLive.Index do
  use BetsWeb, :live_view
  require Logger
  alias Bets.Dashboards
  alias Bets.Dashboards.Dashboard

  @impl true
  def render(assigns) do
    ~H"""
    <div class="dashboard">
      <h1 class="mb-2 font-bold text-center">Dashboard</h1>
      <div class="analytics">
          <div class="game">
            <hr/>
            <ul class ="list-disc text-sm my-2 ">
              <%= for game <- Bets.Games.list_games() do %>
                <li class="leading-8"><%= game.name %></li>
                <li class="leading-8">Start time: <%= game.game_time %></li>
                <li class="leading-8">Status: <%= game.status %></li>
              <% end %>
            </ul>
            <hr/>
          </div>
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
    Logger.info("Handling params: #{inspect(params)} on socket: #{inspect(socket)}")
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

  defp apply_action(socket, :index, _params) do
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
    {:noreply, BetsWeb.UserAuth.log_out_user(socket)}
  end
end
