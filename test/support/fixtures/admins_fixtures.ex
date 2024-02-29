defmodule Bets.AdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bets.Admins` context.
  """

  @doc """
  Generate a admin.
  """
  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Bets.Admins.create_admin()

    admin
  end
end
