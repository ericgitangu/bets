defmodule BetsWeb.FrontendUserLive.Index do
  use BetsWeb, :live_view

  alias Bets.FrontendUsers
  alias Bets.FrontendUsers.FrontendUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :frontendusers, FrontendUsers.list_frontendusers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Frontend user")
    |> assign(:frontend_user, FrontendUsers.get_frontend_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Frontend user")
    |> assign(:frontend_user, %FrontendUser{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Frontendusers")
    |> assign(:frontend_user, nil)
  end

  @impl true
  def handle_info({BetsWeb.FrontendUserLive.FormComponent, {:saved, frontend_user}}, socket) do
    {:noreply, stream_insert(socket, :frontendusers, frontend_user)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    frontend_user = FrontendUsers.get_frontend_user!(id)
    {:ok, _} = FrontendUsers.delete_frontend_user(frontend_user)

    {:noreply, stream_delete(socket, :frontendusers, frontend_user)}
  end
end
