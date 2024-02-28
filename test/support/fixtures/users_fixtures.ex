defmodule Bets.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        encrypted_password: "some encrypted_password",
        first_name: "some first_name",
        last_name: "some last_name",
        msisdn: "some msisdn",
        role: :user
      })
      |> Bets.Users.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name"
      })
      |> Bets.Users.create_user()

    user
  end
end
