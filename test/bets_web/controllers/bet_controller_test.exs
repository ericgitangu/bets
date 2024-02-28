defmodule BetsWeb.BetControllerTest do
  use BetsWeb.ConnCase

  import Bets.WagersFixtures

  @create_attrs %{amount: "120.5"}
  @update_attrs %{amount: "456.7"}
  @invalid_attrs %{amount: nil}

  describe "index" do
    test "lists all bets", %{conn: conn} do
      conn = get(conn, ~p"/bets")
      assert html_response(conn, 200) =~ "Listing Bets"
    end
  end

  describe "new bet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/bets/new")
      assert html_response(conn, 200) =~ "New Bet"
    end
  end

  describe "create bet" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/bets", bet: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/bets/#{id}"

      conn = get(conn, ~p"/bets/#{id}")
      assert html_response(conn, 200) =~ "Bet #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/bets", bet: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Bet"
    end
  end

  describe "edit bet" do
    setup [:create_bet]

    test "renders form for editing chosen bet", %{conn: conn, bet: bet} do
      conn = get(conn, ~p"/bets/#{bet}/edit")
      assert html_response(conn, 200) =~ "Edit Bet"
    end
  end

  describe "update bet" do
    setup [:create_bet]

    test "redirects when data is valid", %{conn: conn, bet: bet} do
      conn = put(conn, ~p"/bets/#{bet}", bet: @update_attrs)
      assert redirected_to(conn) == ~p"/bets/#{bet}"

      conn = get(conn, ~p"/bets/#{bet}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, bet: bet} do
      conn = put(conn, ~p"/bets/#{bet}", bet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Bet"
    end
  end

  describe "delete bet" do
    setup [:create_bet]

    test "deletes chosen bet", %{conn: conn, bet: bet} do
      conn = delete(conn, ~p"/bets/#{bet}")
      assert redirected_to(conn) == ~p"/bets"

      assert_error_sent 404, fn ->
        get(conn, ~p"/bets/#{bet}")
      end
    end
  end

  defp create_bet(_) do
    bet = bet_fixture()
    %{bet: bet}
  end
end
