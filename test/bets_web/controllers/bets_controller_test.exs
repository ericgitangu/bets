defmodule BetsWeb.BetControllerTest do
  use BetsWeb.ConnCase

  import Bets.WagersFixtures

  @create_attrs %{amount: "120.5"}
  @update_attrs %{amount: "456.7"}
  @invalid_attrs %{amount: nil}

  describe "index" do
    test "lists all wagers", %{conn: conn} do
      conn = get(conn, ~p"/wagers")
      assert html_response(conn, 200) =~ "Listing Bets"
    end
  end

  describe "new bet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/wagers/new")
      assert html_response(conn, 200) =~ "New Bet"
    end
  end

  describe "create bet" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/wagers", bet: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/wagers/#{id}"

      conn = get(conn, ~p"/wagers/#{id}")
      assert html_response(conn, 200) =~ "Bet #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/wagers", bet: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Bet"
    end
  end

  describe "edit bet" do
    setup [:create_bet]

    test "renders form for editing chosen bet", %{conn: conn, bet: bet} do
      conn = get(conn, ~p"/wagers/#{bet}/edit")
      assert html_response(conn, 200) =~ "Edit Bet"
    end
  end

  describe "update bet" do
    setup [:create_bet]

    test "redirects when data is valid", %{conn: conn, bet: bet} do
      conn = put(conn, ~p"/wagers/#{bet}", bet: @update_attrs)
      assert redirected_to(conn) == ~p"/wagers/#{bet}"

      conn = get(conn, ~p"/wagers/#{bet}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, bet: bet} do
      conn = put(conn, ~p"/wagers/#{bet}", bet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Bet"
    end
  end

  describe "delete bet" do
    setup [:create_bet]

    test "deletes chosen bet", %{conn: conn, bet: bet} do
      conn = delete(conn, ~p"/wagers/#{bet}")
      assert redirected_to(conn) == ~p"/wagers"

      assert_error_sent 404, fn ->
        get(conn, ~p"/wagers/#{bet}")
      end
    end
  end

  defp create_bet(_) do
    bet = bet_fixture()
    %{bet: bet}
  end
end
