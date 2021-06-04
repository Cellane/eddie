defmodule EddieWeb.Plugs.VerifySignature do
  import EddieWeb.CacheBodyReader
  import Plug.Conn

  def init(channel_secret), do: channel_secret

  def call(conn, channel_secret) do
    with [signature] <- get_req_header(conn, "x-line-signature"),
         body <- read_cached_body(conn),
         expected <- calculate_digest(channel_secret, body),
         :ok <- verify_signature(signature, expected) do
      conn
    else
      _ ->
        conn
        |> halt()
        |> send_resp(:unauthorized, "")
    end
  end

  defp calculate_digest(secret, text) do
    :crypto.mac(:hmac, :sha256, secret, text)
    |> Base.encode64(case: :lower)
  end

  defp verify_signature(signature, expected) when signature == expected, do: :ok
  defp verify_signature(_, _), do: :error
end
