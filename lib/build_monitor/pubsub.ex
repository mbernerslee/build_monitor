defmodule BuildMonitor.PubSub do
  alias Phoenix.PubSub

  @pubsub_topic "build_results"

  def subscribe do
    PubSub.subscribe(BuildMonitor.PubSub, @pubsub_topic)
  end

  def broadcast(build_results) do
    PubSub.broadcast!(BuildMonitor.PubSub, @pubsub_topic, {:build_results, build_results})
  end
end
