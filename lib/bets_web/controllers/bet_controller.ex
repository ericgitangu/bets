defmodule BetsWeb.BetController do
  use BetsWeb, :controller

  alias Bets.Wagers
  alias Bets.Wagers.Bet

  def index(conn, _params) do
    bets = Wagers.list_bets()
    render(conn, :index, bets: bets)
  end

  def new(conn, _params) do
    changeset = Wagers.change_bet(%Bet{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"bet" => bet_params}) do
    case Wagers.create_bet(bet_params) do
      {:ok, bet} ->
        conn
        |> put_flash(:info, "Bet created successfully.")
        |> redirect(to: ~p"/bets/#{bet}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bet = Wagers.get_bet!(id)
    render(conn, :show, bet: bet)
  end

  def edit(conn, %{"id" => id}) do
    bet = Wagers.get_bet!(id)
    changeset = Wagers.change_bet(bet)
    render(conn, :edit, bet: bet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bet" => bet_params}) do
    bet = Wagers.get_bet!(id)

    case Wagers.update_bet(bet, bet_params) do
      {:ok, bet} ->
        conn
        |> put_flash(:info, "Bet updated successfully.")
        |> redirect(to: ~p"/bets/#{bet}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, bet: bet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bet = Wagers.get_bet!(id)
    {:ok, _bet} = Wagers.delete_bet(bet)

    conn
    |> put_flash(:info, "Bet deleted successfully.")
    |> redirect(to: ~p"/bets")
  end
end
