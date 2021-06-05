defmodule EddieWeb.EventController do
  use EddieWeb, :controller

  action_fallback(EddieWeb.FallbackController)

  def process(conn, %{"events" => []}) do
    send_resp(conn, :ok, "")
  end

  def process(conn, %{"events" => events}) do
    events
    |> Enum.filter(fn event -> event["mode"] == "active" end)
    |> Enum.each(fn event ->
      Eddie.EventSupervisor.process(event["type"], event)
    end)

    send_resp(conn, :ok, "")
  end
end
