defmodule Bets.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name"
      })

    {:ok, user} = Bets.Accounts.User.create_user(attrs)

    user
  end
end
