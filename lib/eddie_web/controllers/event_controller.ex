defmodule EddieWeb.EventController do
  use EddieWeb, :controller

  action_fallback(EddieWeb.FallbackController)

  def process(conn, params) do
    send_resp(conn, :ok, "")
  end
end
