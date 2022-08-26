defmodule BuildMonitorWeb.DashboardLive.Index do
  use BuildMonitorWeb, :live_view
  alias BuildMonitor.{PubSub, Server}

  def mount(_params, _, socket) do
    if connected?(socket) do
      PubSub.subscribe()
    end

    socket =
      socket
      |> assign(:build_results, Server.get_results())

    {:ok, socket}
  end

  def handle_info({:build_results, build_results}, socket) do
    {:noreply, update(socket, :build_results, fn _ -> build_results end)}
  end

  def render(assigns) do
    ~H"""
    <h1>CI builds!</h1>
      <table>
        <tr>
          <th>Event</th>
          <th>Project</th>
          <th>Branch</th>
          <th>Author</th>
          <th>Committer</th>
          <th>Git Commit Message</th>
          <th>When?</th>
        </tr>

      <%= for build_result <- @build_results do %>
        <tr>
          <%= case build_result do %>

            <% %{
             "pipeline" => %{
               "created_at" => created_at,
               "vcs" => %{
                 "branch" => branch,
                 "commit" => %{
                   "author" => %{"name" => author},
                   "committer" => %{"name" => committer},
                   "subject" => git_commit_message
                 },
               }
             },
             "project" => %{"name" => project},
             "type" => "workflow-completed",
             "workflow" => %{"status" => status}
            }  -> %>
              <td>Workflow completed: <%= status %></td>
              <td><%= project %></td>
              <td><%= branch %></td>
              <td><%= author %></td>
              <td><%= committer %></td>
              <td><%= git_commit_message %></td>
              <td><%= render_datetime(created_at) %></td>

            <% %{
              "pipeline" => %{
                "created_at" => created_at,
                "vcs" => %{
                  "branch" => branch,
                  "commit" => %{
                    "author" => %{"name" => author},
                    "committer" => %{"name" => committer},
                    "subject" => git_commit_message
                  },
                }
              },
              "project" => %{"name" => project},
              "type" => "job-completed",
            } -> %>

              <td>Job completed!</td>
              <td><%= project %></td>
              <td><%= branch %></td>
              <td><%= author %></td>
              <td><%= committer %></td>
              <td><%= git_commit_message %></td>
              <td><%= render_datetime(created_at) %></td>

            <% %{"type" => "ping"} -> %>
              <td>Test ping!</td>
              <td>-</td>
              <td>-</td>
              <td>-</td>
              <td>-</td>
              <td>-</td>
              <td>-</td>

            <% unrecognised -> %>
              <td>Unrecognised output!</td>
              <td><%= inspect(unrecognised) %></td>


          <% end %>
        </tr>
      <% end %>
    </table>
    """

    # %{
    #  "happened_at" => "2022-08-15T16:10:45.575752Z",
    #  "id" => "6484cd45-14b5-3e87-93fd-984d3e2366d6",
    #  "organization" => %{"id" => "a06ba470-3198-4db9-82d7-ede59932ddea", "name" => "mbernerslee"},
    #  "pipeline" => %{
    #    "created_at" => "2022-08-15T15:41:27.252Z",
    #    "id" => "1edf02b6-7df4-4019-84f6-fffd47684b8e",
    #    "number" => 20,
    #    "trigger" => %{"type" => "webhook"},
    #    "vcs" => %{
    #      "branch" => "master",
    #      "commit" => %{
    #        "author" => %{"email" => "matthewbernerslee@gmail.com", "name" => "berners"},
    #        "authored_at" => "2022-08-15T15:41:23Z",
    #        "body" => "",
    #        "committed_at" => "2022-08-15T15:41:23Z",
    #        "committer" => %{"email" => "matthewbernerslee@gmail.com", "name" => "berners"},
    #        "subject" => "seems to work now?"
    #      },
    #      "origin_repository_url" => "https://github.com/mbernerslee/build_monitor",
    #      "provider_name" => "github",
    #      "revision" => "4fc821b9c8069f4f0eb8d76eff7de518e8d15905",
    #      "target_repository_url" => "https://github.com/mbernerslee/build_monitor"
    #    }
    #  },
    #  "project" => %{
    #    "id" => "9b4aef76-0aaa-4f84-bf64-efd455312048",
    #    "name" => "build_monitor",
    #    "slug" => "github/mbernerslee/build_monitor"
    #  },
    #  "type" => "workflow-completed",
    #  "webhook" => %{"id" => "e38401f0-35a7-413a-83f5-1075910ba2f8", "name" => "build monitor"},
    #  "workflow" => %{
    #    "created_at" => "2022-08-15T16:09:38.460Z",
    #    "id" => "21d2b26d-3e0b-49ce-af22-0866b9ca508e",
    #    "name" => "workflow",
    #    "status" => "success",
    #    "stopped_at" => "2022-08-15T16:10:45.470Z",
    #    "url" =>
    #      "https://app.circleci.com/pipelines/github/mbernerslee/build_monitor/20/workflows/21d2b26d-3e0b-49ce-af22-0866b9ca508e"
    #  }
    # }
    #
    #
    #
    #
    #
    #
    # %{
    #  "happened_at" => "2022-08-15T16:48:14.549900Z",
    #  "id" => "d243eb07-66a3-3e98-ba78-f93432c47680",
    #  "job" => %{
    #    "id" => "db950b56-d2b5-4613-b3f0-84881ece1ca7",
    #    "name" => "build",
    #    "number" => 24,
    #    "started_at" => "2022-08-15T16:47:09.974Z",
    #    "status" => "success",
    #    "stopped_at" => "2022-08-15T16:48:14.480Z"
    #  },
    #  "organization" => %{"id" => "a06ba470-3198-4db9-82d7-ede59932ddea", "name" => "mbernerslee"},
    #  "pipeline" => %{
    #    "created_at" => "2022-08-15T15:41:27.252Z",
    #    "id" => "1edf02b6-7df4-4019-84f6-fffd47684b8e",
    #    "number" => 20,
    #    "trigger" => %{"type" => "webhook"},
    #    "vcs" => %{
    #      "branch" => "master",
    #      "commit" => %{
    #        "author" => %{"email" => "matthewbernerslee@gmail.com", "name" => "berners"},
    #        "authored_at" => "2022-08-15T15:41:23Z",
    #        "body" => "",
    #        "committed_at" => "2022-08-15T15:41:23Z",
    #        "committer" => %{"email" => "matthewbernerslee@gmail.com", "name" => "berners"},
    #        "subject" => "seems to work now?"
    #      },
    #      "origin_repository_url" => "https://github.com/mbernerslee/build_monitor",
    #      "provider_name" => "github",
    #      "revision" => "4fc821b9c8069f4f0eb8d76eff7de518e8d15905",
    #      "target_repository_url" => "https://github.com/mbernerslee/build_monitor"
    #    }
    #  },
    #  "project" => %{
    #    "id" => "9b4aef76-0aaa-4f84-bf64-efd455312048",
    #    "name" => "build_monitor",
    #    "slug" => "github/mbernerslee/build_monitor"
    #  },
    #  "type" => "job-completed",
    #  "webhook" => %{"id" => "e38401f0-35a7-413a-83f5-1075910ba2f8", "name" => "build monitor"},
    #  "workflow" => %{
    #    "created_at" => "2022-08-15T16:47:07.627Z",
    #    "id" => "3ebb14db-89ce-4f79-89ca-e7a41cfb85e9",
    #    "name" => "workflow",
    #    "stopped_at" => "2022-08-15T16:48:14.480Z",
    #    "url" =>
    #      "https://app.circleci.com/pipelines/github/mbernerslee/build_monitor/20/workflows/3ebb14db-89ce-4f79-89ca-e7a41cfb85e9"
    #  }
    # }
  end

  defp render_datetime(datetime) do
    case DateTime.from_iso8601(datetime) do
      {:ok, %{year: year, month: month, day: day, hour: hour, minute: minute, second: second}, _} ->
        "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"

      fail ->
        "oops, failed with #{inspect(fail)}"
    end
  end
end
