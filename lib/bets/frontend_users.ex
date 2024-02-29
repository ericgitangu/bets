defmodule Bets.FrontendUsers do
  @moduledoc """
  The FrontendUsers context.
  """

  import Ecto.Query, warn: false
  alias Bets.Repo

  alias Bets.FrontendUsers.FrontendUser

  @doc """
  Returns the list of frontendusers.

  ## Examples

      iex> list_frontendusers()
      [%FrontendUser{}, ...]

  """
  def list_frontendusers do
    Repo.all(FrontendUser)
  end

  @doc """
  Gets a single frontend_user.

  Raises `Ecto.NoResultsError` if the Frontend user does not exist.

  ## Examples

      iex> get_frontend_user!(123)
      %FrontendUser{}

      iex> get_frontend_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_frontend_user!(id), do: Repo.get!(FrontendUser, id)

  @doc """
  Creates a frontend_user.

  ## Examples

      iex> create_frontend_user(%{field: value})
      {:ok, %FrontendUser{}}

      iex> create_frontend_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_frontend_user(attrs \\ %{}) do
    %FrontendUser{}
    |> FrontendUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a frontend_user.

  ## Examples

      iex> update_frontend_user(frontend_user, %{field: new_value})
      {:ok, %FrontendUser{}}

      iex> update_frontend_user(frontend_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_frontend_user(%FrontendUser{} = frontend_user, attrs) do
    frontend_user
    |> FrontendUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a frontend_user.

  ## Examples

      iex> delete_frontend_user(frontend_user)
      {:ok, %FrontendUser{}}

      iex> delete_frontend_user(frontend_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_frontend_user(%FrontendUser{} = frontend_user) do
    Repo.delete(frontend_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking frontend_user changes.

  ## Examples

      iex> change_frontend_user(frontend_user)
      %Ecto.Changeset{data: %FrontendUser{}}

  """
  def change_frontend_user(%FrontendUser{} = frontend_user, attrs \\ %{}) do
    FrontendUser.changeset(frontend_user, attrs)
  end
end
