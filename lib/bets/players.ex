defmodule Bets.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias Bets.Repo
  alias Bets.Players.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(%Ueberauth.Auth.Info{name: name, email: email} = _attrs) do
    [first_name, last_name | _tail] = String.split(name, " ")
    IO.inspect(first_name, label: "first")
    IO.inspect(last_name, label: "last")
    IO.inspect(email, label: "email")

    Player.changeset(%Player{}, %{
      first_name: first_name,
      last_name: last_name,
      email: email,
      role: "user"
    })
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  def create_users(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  def get_or_create_user(_conn, attrs) do
    case Repo.get_by(Player, email: "#attrs.email") do
      nil -> create_player(attrs)
      {:error, _reason} = error -> error
      user -> {:ok, user}
    end
  end
end
