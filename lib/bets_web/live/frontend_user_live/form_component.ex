defmodule BetsWeb.FrontendUserLive.FormComponent do
  use BetsWeb, :live_component

  alias Bets.FrontendUsers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage frontend_user records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="frontend_user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Frontend user</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{frontend_user: frontend_user} = assigns, socket) do
    changeset = FrontendUsers.change_frontend_user(frontend_user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"frontend_user" => frontend_user_params}, socket) do
    changeset =
      socket.assigns.frontend_user
      |> FrontendUsers.change_frontend_user(frontend_user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"frontend_user" => frontend_user_params}, socket) do
    save_frontend_user(socket, socket.assigns.action, frontend_user_params)
  end

  defp save_frontend_user(socket, :edit, frontend_user_params) do
    case FrontendUsers.update_frontend_user(socket.assigns.frontend_user, frontend_user_params) do
      {:ok, frontend_user} ->
        notify_parent({:saved, frontend_user})

        {:noreply,
         socket
         |> put_flash(:info, "Frontend user updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_frontend_user(socket, :new, frontend_user_params) do
    case FrontendUsers.create_frontend_user(frontend_user_params) do
      {:ok, frontend_user} ->
        notify_parent({:saved, frontend_user})

        {:noreply,
         socket
         |> put_flash(:info, "Frontend user created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
