defmodule Eddie.LINE.API do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.line.me/v2/bot")

  plug(Tesla.Middleware.Headers, [
    {"Authorization", "Bearer " <> Application.get_env(:eddie, :line)[:channel_access_token]}
  ])

  plug(Tesla.Middleware.JSON)

  def profile(user_id) do
    with {:ok, response} <- get("/profile/" <> user_id),
         200 <- response.status(),
         body <- response.body() |> underscore_keys do
      {:ok, body}
    else
      {:error, error} -> {:error, error}
      other -> {:error, other}
    end
  end

  def send_reply(messages, reply_token) do
    with {:ok, response} <-
           post("/message/reply", %{replyToken: reply_token, messages: messages}),
         200 <- response.status() do
      :ok
    else
      _ -> :error
    end
  end

  defp underscore_keys(nil), do: nil

  defp underscore_keys(%{} = map) do
    map
    |> Enum.map(fn {k, v} -> {Macro.underscore(k), underscore_keys(v)} end)
    |> Enum.map(fn {k, v} -> {String.replace(k, "-", "_"), v} end)
    |> Enum.into(%{})
  end

  defp underscore_keys([head | rest]) do
    [underscore_keys(head) | underscore_keys(rest)]
  end

  defp underscore_keys(not_a_map) do
    not_a_map
  end
end
