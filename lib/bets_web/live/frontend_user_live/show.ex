defmodule BetsWeb.FrontendUserLive.Show do
  use BetsWeb, :live_view

  alias Bets.FrontendUsers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:frontend_user, FrontendUsers.get_frontend_user!(id))}
  end

  @impl true
  def handle_info(%{"game_started" => %{"game_id" => game_id}}, socket) do
    # Update LiveView assigns to reflect the game has started
    {:noreply, assign(socket, game_id: game_id, game_status: "started")}
  end

  @impl true
  def handle_info(%{"game_ended" => %{"game_id" => game_id, "winner" => winner}}, socket) do
    # Update LiveView assigns to show the game has ended and the winner
    {:noreply, assign(socket, game_id: game_id, game_status: "ended", winner: winner)}
  end

  defp page_title(:show), do: "Show Frontend user"
  defp page_title(:edit), do: "Edit Frontend user"
end
