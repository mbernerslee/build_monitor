defmodule BuildMonitor.PubSub do
  alias Phoenix.PubSub

  @pubsub_topic "ci-build-response"

  def subscribe do
    PubSub.subscribe(BuildMonitor.PubSub, @pubsub_topic)
  end

  def broadcast(ci_build_response) do
    PubSub.broadcast!(BuildMonitor.PubSub, @pubsub_topic, {:ci_build_response, ci_build_response})
  end
end
