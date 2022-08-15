defmodule BuildMonitorWeb.DashboardLive.Index do
  use BuildMonitorWeb, :live_view
  alias BuildMonitor.PubSub

  def mount(_params, x, socket) do
    IO.inspect(x)

    if connected?(socket) do
      IO.inspect("Subscribing now!!")
      PubSub.subscribe()
    end

    socket =
      socket
      |> assign(:ci_build_responses, [])

    {:ok, socket}
  end

  def handle_info({:ci_build_response, ci_build_response}, socket) do
    IO.inspect(ci_build_response, label: "DashboardLive.Index handle_info")
    {:noreply, update(socket, :ci_build_responses, &[ci_build_response | &1])}
  end

  def render(assigns) do
    ~H"""
    <h1>CI builds!</h1>
    <ul>
      <%= for ci_build_response <- @ci_build_responses do %>
        <li>
          <%= "#{inspect(ci_build_response)}" %>
        </li>
      <% end %>
    </ul>
    """
  end
end
