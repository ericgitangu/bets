defmodule BetsWeb.GameRoomChannel do
  use BetsWeb, :channel

  @impl true
  def join("game:lobby", _payload, socket) do
    IO.puts("User joined game lobby")
    {:ok, %{}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("game_started", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game_room:lobby).
  @impl true
  def handle_in("game_ended", payload, socket) do
    broadcast(socket, "Game round has ended!", payload)
    {:noreply, socket}
  end
end
