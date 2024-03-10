defmodule Bets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    Oban.Telemetry.attach_default_logger()

    children = [
      BetsWeb.Telemetry,
      Bets.Repo,
      {DNSCluster, query: Application.get_env(:bets, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bets.PubSub},
      {Oban, Application.fetch_env!(:bets, Oban)},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bets.Finch},

      # Start a worker by calling: Bets.Worker.start_link(arg)
      # %{game_id: 1} |> Bets.Games.GameRoundJob.new() |> Oban.insert(),
      # Start to serve requests, typically the last entry
      BetsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Bets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BetsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
