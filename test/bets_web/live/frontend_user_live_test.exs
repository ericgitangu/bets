defmodule BetsWeb.FrontendUserLiveTest do
  use BetsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bets.FrontendUsersFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_frontend_user(_) do
    frontend_user = frontend_user_fixture()
    %{frontend_user: frontend_user}
  end

  describe "Index" do
    setup [:create_frontend_user]

    test "lists all frontendusers", %{conn: conn, frontend_user: frontend_user} do
      {:ok, _index_live, html} = live(conn, ~p"/frontendusers")

      assert html =~ "Listing Frontendusers"
      assert html =~ frontend_user.name
    end

    test "saves new frontend_user", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/frontendusers")

      assert index_live |> element("a", "New Frontend user") |> render_click() =~
               "New Frontend user"

      assert_patch(index_live, ~p"/frontendusers/new")

      assert index_live
             |> form("#frontend_user-form", frontend_user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#frontend_user-form", frontend_user: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/frontendusers")

      html = render(index_live)
      assert html =~ "Frontend user created successfully"
      assert html =~ "some name"
    end

    test "updates frontend_user in listing", %{conn: conn, frontend_user: frontend_user} do
      {:ok, index_live, _html} = live(conn, ~p"/frontendusers")

      assert index_live |> element("#frontendusers-#{frontend_user.id} a", "Edit") |> render_click() =~
               "Edit Frontend user"

      assert_patch(index_live, ~p"/frontendusers/#{frontend_user}/edit")

      assert index_live
             |> form("#frontend_user-form", frontend_user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#frontend_user-form", frontend_user: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/frontendusers")

      html = render(index_live)
      assert html =~ "Frontend user updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes frontend_user in listing", %{conn: conn, frontend_user: frontend_user} do
      {:ok, index_live, _html} = live(conn, ~p"/frontendusers")

      assert index_live |> element("#frontendusers-#{frontend_user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#frontendusers-#{frontend_user.id}")
    end
  end

  describe "Show" do
    setup [:create_frontend_user]

    test "displays frontend_user", %{conn: conn, frontend_user: frontend_user} do
      {:ok, _show_live, html} = live(conn, ~p"/frontendusers/#{frontend_user}")

      assert html =~ "Show Frontend user"
      assert html =~ frontend_user.name
    end

    test "updates frontend_user within modal", %{conn: conn, frontend_user: frontend_user} do
      {:ok, show_live, _html} = live(conn, ~p"/frontendusers/#{frontend_user}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Frontend user"

      assert_patch(show_live, ~p"/frontendusers/#{frontend_user}/show/edit")

      assert show_live
             |> form("#frontend_user-form", frontend_user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#frontend_user-form", frontend_user: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/frontendusers/#{frontend_user}")

      html = render(show_live)
      assert html =~ "Frontend user updated successfully"
      assert html =~ "some updated name"
    end
  end
end
