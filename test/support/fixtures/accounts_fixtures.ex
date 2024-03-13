defmodule Bets.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        admin_id: 42,
        bet_id: 42,
        confirmed_at: ~N[2024-03-11 21:42:00],
        email: "some email",
        game_id: 42,
        hashed_password: "some hashed_password",
        name: "some name",
        player_id: 42,
        role: :user
      })
      |> Bets.Accounts.User.create_user()

    user
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
