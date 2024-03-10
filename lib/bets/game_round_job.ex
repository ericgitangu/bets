defmodule Bets.Games.GameRoundJob do
  use Oban.Worker, queue: :games, max_attempts: 3
  require Logger

  alias Bets.Games
  alias BetsWeb.Endpoint

  # Will get back to this,  I was trying to figure out how to start the game round job
  # using Oban to schedule the game round to start in 2 minutes, announces the next round
  # and then ends the game. Using sockets to broadcast the game start and end events to the
  # client - Not Working! Struggled with this in the interest of time, will get back to it.ime

  @impl true
  def perform(%Oban.Job{args: %{"game_id" => game_id}}) do
    case Games.start_game(game_id) do
      {:ok, _game} ->
        Endpoint.broadcast("games:lobby", "game_started", %{game_id: game_id})

      {:error, reason} ->
        # IO.inspect("Failed to start game: #{reason}", label: "GameRoundJob Failed to start game")
        Logger.error("Failed to start game: #{reason}")
    end

    # Simulate game round duration of 2 minutes
    Process.sleep(120_000)

    case Games.end_game(game_id) do
      {:ok, game_result} ->
        Endpoint.broadcast("games:lobby", "game_ended", %{game_id: game_id, winner: game_result})

      {:error, reason} ->
        Logger.error("Failed to end game: #{reason}")
    end

    #   # Schedule the next game round to start in 2 minutes
    Oban.insert(%Oban.Job{
      worker: __MODULE__,
      args: %{"game_id" => game_id},
      queue: "games",
      # 120 seconds for 2 minutes
      scheduled_at: DateTime.add(DateTime.utc_now(), 120)
    })
  end
end
