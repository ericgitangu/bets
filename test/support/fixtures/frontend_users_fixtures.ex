defmodule Bets.FrontendUsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.FrontendUsers` context.
  """

  @doc """
  Generate a frontend_user.
  """
  def frontend_user_fixture(attrs \\ %{}) do
    {:ok, frontend_user} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Bets.FrontendUsers.create_frontend_user()

    frontend_user
  end
end
