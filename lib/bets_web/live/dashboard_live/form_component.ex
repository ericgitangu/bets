defmodule BetsWeb.DashboardLive.FormComponent do
  use BetsWeb, :live_component

  alias Bets.Dashboards

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage dashboard records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="dashboard-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:upcoming_games]} type="text" label="Upcoming games" />
        <.input field={@form[:past_games]} type="text" label="Past games" />
        <.input field={@form[:past_games_winner]} type="text" label="Past games winner" />
        <.input field={@form[:count_down]} type="text" label="Count down" />
        <.input
          field={@form[:game_genre]}
          type="select"
          label="Game genre"
          prompt="Choose a value"
          options={Ecto.Enum.values(Bets.Dashboards.Dashboard, :game_genre)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Dashboard</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{dashboard: dashboard} = assigns, socket) do
    changeset = Dashboards.change_dashboard(dashboard)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"dashboard" => dashboard_params}, socket) do
    changeset =
      socket.assigns.dashboard
      |> Dashboards.change_dashboard(dashboard_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"dashboard" => dashboard_params}, socket) do
    save_dashboard(socket, socket.assigns.action, dashboard_params)
  end

  defp save_dashboard(socket, :edit, dashboard_params) do
    case Dashboards.update_dashboard(socket.assigns.dashboard, dashboard_params) do
      {:ok, dashboard} ->
        notify_parent({:saved, dashboard})

        {:noreply,
         socket
         |> put_flash(:info, "Dashboard updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_dashboard(socket, :new, dashboard_params) do
    case Dashboards.create_dashboard(dashboard_params) do
      {:ok, dashboard} ->
        notify_parent({:saved, dashboard})

        {:noreply,
         socket
         |> put_flash(:info, "Dashboard created successfully")
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
