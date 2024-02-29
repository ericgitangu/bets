defmodule Bets.FrontendUsersTest do
  use Bets.DataCase

  alias Bets.FrontendUsers

  describe "frontendusers" do
    alias Bets.FrontendUsers.FrontendUser

    import Bets.FrontendUsersFixtures

    @invalid_attrs %{name: nil}

    test "list_frontendusers/0 returns all frontendusers" do
      frontend_user = frontend_user_fixture()
      assert FrontendUsers.list_frontendusers() == [frontend_user]
    end

    test "get_frontend_user!/1 returns the frontend_user with given id" do
      frontend_user = frontend_user_fixture()
      assert FrontendUsers.get_frontend_user!(frontend_user.id) == frontend_user
    end

    test "create_frontend_user/1 with valid data creates a frontend_user" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %FrontendUser{} = frontend_user} = FrontendUsers.create_frontend_user(valid_attrs)
      assert frontend_user.name == "some name"
    end

    test "create_frontend_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FrontendUsers.create_frontend_user(@invalid_attrs)
    end

    test "update_frontend_user/2 with valid data updates the frontend_user" do
      frontend_user = frontend_user_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %FrontendUser{} = frontend_user} = FrontendUsers.update_frontend_user(frontend_user, update_attrs)
      assert frontend_user.name == "some updated name"
    end

    test "update_frontend_user/2 with invalid data returns error changeset" do
      frontend_user = frontend_user_fixture()
      assert {:error, %Ecto.Changeset{}} = FrontendUsers.update_frontend_user(frontend_user, @invalid_attrs)
      assert frontend_user == FrontendUsers.get_frontend_user!(frontend_user.id)
    end

    test "delete_frontend_user/1 deletes the frontend_user" do
      frontend_user = frontend_user_fixture()
      assert {:ok, %FrontendUser{}} = FrontendUsers.delete_frontend_user(frontend_user)
      assert_raise Ecto.NoResultsError, fn -> FrontendUsers.get_frontend_user!(frontend_user.id) end
    end

    test "change_frontend_user/1 returns a frontend_user changeset" do
      frontend_user = frontend_user_fixture()
      assert %Ecto.Changeset{} = FrontendUsers.change_frontend_user(frontend_user)
    end
  end
end
