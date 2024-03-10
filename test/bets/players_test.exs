defmodule Bets.PlayersTest do
  use Bets.DataCase

  alias Bets.Players

  describe "players" do
    alias Bets.Players.Player

    import Bets.PlayersFixtures

    @invalid_attrs %{
      role: nil,
      first_name: nil,
      last_name: nil,
      email: nil,
      encrypted_password: nil,
      msisdn: nil
    }

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Players.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Players.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      valid_attrs = %{
        role: :user,
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some email",
        encrypted_password: "some encrypted_password",
        msisdn: "some msisdn"
      }

      assert {:ok, %Player{} = player} = Players.create_player(valid_attrs)
      assert player.role == :user
      assert player.first_name == "some first_name"
      assert player.last_name == "some last_name"
      assert player.email == "some email"
      assert player.encrypted_password == "some encrypted_password"
      assert player.msisdn == "some msisdn"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()

      update_attrs = %{
        role: :user,
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        email: "some updated email",
        encrypted_password: "some updated encrypted_password",
        msisdn: "some updated msisdn"
      }

      assert {:ok, %Player{} = player} = Players.update_player(player, update_attrs)
      assert player.role == :user
      assert player.first_name == "some updated first_name"
      assert player.last_name == "some updated last_name"
      assert player.email == "some updated email"
      assert player.encrypted_password == "some updated encrypted_password"
      assert player.msisdn == "some updated msisdn"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Players.update_player(player, @invalid_attrs)
      assert player == Players.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Players.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Players.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Players.change_player(player)
    end
  end
end
