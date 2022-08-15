defmodule BuildMonitorWeb.PageController do
  use BuildMonitorWeb, :controller
  alias BuildMonitor.PubSub

  # def index(conn, _params) do
  #  render(conn, "index.html")
  # end

  def circle_ci(conn, params) do
    IO.inspect(params)
    PubSub.broadcast(params)

    # %{"happened_at" => "2022-08-15T15:05:29.231903Z", "id" => "c550494f-2cb0-4286-bde0-92bda7184040", "type" => "ping", "webhook" => %{"id" => "e38401f0-35a7-413a-83f5-1075910ba2f8", "name" => "build monitor"}}
    send_resp(conn, 200, "")
  end
end
