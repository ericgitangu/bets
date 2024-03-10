defmodule BetsWeb.GameRoomChannel do
  """
  Handle the "game_started" message and perform necessary actions.

  ## Params

  - `game_id` - The identifier of the started game.
  - `socket` - The WebSocket connection socket.

  ## Returns

  The updated socket.

  """

  use BetsWeb, :channel
  require Logger

  @impl true
  def join("game:lobby", payload, socket) do
    Logger.info("User just joined the betting lobby with payload: #{inspect(payload)}")
    {:ok, %{Welcome: "You've successfully joined the betting lobby"}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client

  @impl true
  def handle_in("bet_placed", payload, socket) do
    Logger.info("Bet placed with payload: #{inspect(payload)}")
    {:reply, {:ok, %{bet: "Bet placed"}}, socket}
  end

  @impl true
  def handle_in("place_bet", payload, socket) do
    Logger.info("Bet placed with payload: #{inspect(payload)}")
    {:reply, {:ok, %{bet: "Bet placed"}}, socket}
  end

  @impl true
  def handle_in("game_started", payload, socket) do
    Logger.info("Game started with payload: #{inspect(payload)}")
    {:reply, {:ok, %{game: "Game started"}}, socket}
  end

  @impl true
  def handle_in("game_ended", payload, socket) do
    Logger.info("Game ended with payload: #{inspect(payload)}")
    {:reply, {:ok, %{game: "Game ended"}}, socket}
  end

  @impl true
  def handle_out("game_started", %{game_id: game_id}, socket) do
    Logger.info("Game started with game_id: #{game_id}")
    broadcast(socket, "game_started", %{game_id: game_id})

    {:noreply, socket}
  end

  def handle_out("game_ended", %{game_id: game_id, winner: winner}, socket) do
    broadcast!(socket, "game_ended", %{game_id: game_id, winner: winner})
    {:noreply, socket}
  end
end
