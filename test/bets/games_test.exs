defmodule Bets.GamesTest do
  use Bets.DataCase

  alias Bets.Games

  describe "games" do
    alias Bets.Games.Game

    import Bets.GamesFixtures

    @invalid_attrs %{name: nil, status: nil, game_time: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{name: "some name", status: "some status", game_time: "2024-02-28T21:56:45Z"}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.name == "some name"
      assert game.status == "some status"
      assert game.game_time == ~N[2024-02-28T21:56:45Z]
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()

      update_attrs = %{
        name: "some updated name",
        status: "some updated status",
        game_time: "2024-02-28T21:56:45Z"
      }

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.name == "some updated name"
      assert game.status == "some updated status"
      assert game.game_time == ~N[2024-02-28T21:56:45Z]
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end

  describe "games" do
    alias Bets.Games.Game

    import Bets.GamesFixtures

    @invalid_attrs %{name: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.name == "some name"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.name == "some updated name"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end

  describe "games" do
    alias Bets.Games.Game

    import Bets.GamesFixtures

    @invalid_attrs %{name: nil, status: nil, game_time: nil, user_id: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{
        name: "some name",
        status: :upcoming,
        game_time: ~N[2024-03-03 13:53:00],
        user_id: 42
      }

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.name == "some name"
      assert game.status == :upcoming
      assert game.game_time == ~N[2024-03-03 13:53:00]
      assert game.user_id == 42
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()

      update_attrs = %{
        name: "some updated name",
        status: :upcoming,
        game_time: ~N[2024-03-04 13:53:00],
        user_id: 43
      }

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.name == "some updated name"
      assert game.status == :upcoming
      assert game.game_time == ~N[2024-03-04 13:53:00]
      assert game.user_id == 43
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end
