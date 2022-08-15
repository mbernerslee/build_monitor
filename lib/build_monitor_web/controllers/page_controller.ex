defmodule BuildMonitorWeb.PageController do
  use BuildMonitorWeb, :controller
  alias BuildMonitor.{PubSub, Server}

  def circle_ci(conn, params) do
    Server.add_new_ci_build_result(params)
    PubSub.broadcast(params)
    send_resp(conn, 200, "")
  end
end
