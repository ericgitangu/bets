defmodule BetsWeb.GameController do
  use BetsWeb, :controller

  import Ecto
  alias Bets.Games
  alias Bets.Games.Game

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, :index, games: games)
  end

  def new(conn, _params) do
    changeset = Games.change_game(%Game{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"game" => game_params}) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:games)
      |> build_assoc(:bets)
      |> Game.changeset(game_params)

    case Bets.Repo.insert(changeset) do
      {:ok, game} ->
        conn
        |> put_session(:game, game)
        |> put_session(:game_id, game.id)
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: ~p"/games/#{game}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    render(conn, :show, game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    changeset = Games.change_game(game)
    render(conn, :edit, game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Games.get_game!(id)

    case Games.update_game(game, game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: ~p"/games/#{game}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    {:ok, _game} = Games.delete_game(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: ~p"/games")
  end
end
