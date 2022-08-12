defmodule BuildMonitor.Repo do
  use Ecto.Repo,
    otp_app: :build_monitor,
    adapter: Ecto.Adapters.Postgres
end
