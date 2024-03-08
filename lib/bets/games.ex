defmodule Bets.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Bets.Repo

  alias Bets.Games.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Starts a game.

  ## Examples

      iex> start_game(game)
      {:ok, %Game{}}

      iex> start_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def start_game(%{"id" => id}) do
    game = get_game!(id) # Retrieve the game record using `get_game!` function

    updated_game = update_game(game, %{status: "started"}) # Update the game status

    {:ok, updated_game} # Return the updated game record
  end
  @doc """
  Ends a game.

  ## Examples

      iex> end_game(game)
      {:ok, %Game{}}

      iex> end_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def end_game(%{"id" => id}) do
    game = get_game!(id) # Retrieve the game record using `get_game!` function
    updated_game = update_game(game, %{status: "completed"}) # Update the game status
    player = Repo.get(Player, game.player_id) # Retrieve the player record based on the game's player_id field
    {:ok, {updated_game, player}} # Return the updated game record and player record as a tuple
  end

  def get_past_games(page \\ 1, per_page \\ 10) do
    query = from(g in Game, order_by: [asc: g.game_at, asc: g.id])
    Game
    |> where([g], g.created_at <= ^DateTime.utc_now())
    |> order_by(desc: :created_at)
    |> Repo.paginate(query, cursor_fields: [:game_at, :id], limit: per_page)
    |> Repo.all()
  end

end
