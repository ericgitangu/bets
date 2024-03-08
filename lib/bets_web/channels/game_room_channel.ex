defmodule BetsWeb.GameRoomChannel do
  use BetsWeb, :channel

  @impl true
  def join("game:lobby", payload, socket) do
    IO.inspect(payload, label: "Incoming payload from joining client:")
    {:ok, %{Welcome: "You've successfully joined the betting lobby"}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client

  @impl true
  def handle_in("bet_placed", payload, socket) do
    IO.inspect(payload, label: "Incoming payload from client:")
    {:reply, {:ok, %{games: "Here are the games"}}, socket}
  end

  @impl true
  def handle_in("place_bet", payload, socket) do
    IO.inspect(payload, label: "Incoming payload from client:")
    {:reply, {:ok, %{bet: "Bet placed"}}, socket}
  end

  @impl true
  def handle_in("game_started", payload, socket) do
    IO.inspect(payload, label: "Incoming payload from client:")
    {:reply, {:ok, %{game: "Game started"}}, socket}
  end

  @impl true
  def handle_in("game_ended", payload, socket) do
    IO.inspect(payload, label: "Incoming payload from client:")
    {:reply, {:ok, %{game: "Game ended"}}, socket}
  end

  @impl true
  def handle_out("game_started", %{game_id: game_id}, socket) do
    broadcast!(socket, "game_started", %{game_id: game_id})
    {:noreply, socket}
  end

  def handle_out("game_ended", %{game_id: game_id, winner: winner}, socket) do
    broadcast!(socket, "game_ended", %{game_id: game_id, winner: winner})
    {:noreply, socket}
  end
end
