defmodule BuildMonitor.Server do
  use GenServer
  alias BuildMonitor.PubSub

  @process_name :server

  @default_options [name: @process_name]

  def child_spec do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [@default_options]}
    }
  end

  def start_link(genserver_options \\ @default_options) do
    GenServer.start_link(__MODULE__, nil, genserver_options)
  end

  def add_new_ci_build_result(pid_or_name \\ @process_name, new_build_result) do
    GenServer.cast(pid_or_name, {:new_build_result, new_build_result})
  end

  def get_results(pid_or_name \\ @process_name) do
    GenServer.call(pid_or_name, :get_results)
  end

  @impl true
  def init(_init_arg \\ nil) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:new_build_result, new_build_result}, build_results) do
    build_results = [new_build_result | build_results]
    PubSub.broadcast(build_results)
    {:noreply, build_results}
  end

  @impl true
  def handle_call(:get_results, _from, build_results) do
    {:reply, build_results, build_results}
  end
end
