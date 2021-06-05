defmodule Eddie.LINE.Handler.Follow do
  alias Eddie.LINE
  alias Eddie.LINE.API

  def follow(%{"replyToken" => reply_token, "source" => %{"type" => "user", "userId" => user_id}}) do
    {:ok, profile} = API.profile(user_id)

    LINE.user_followed(profile)
    |> follow_message()
    |> API.send_reply(reply_token)
  end

  def unfollow(%{"source" => %{"type" => "user", "userId" => user_id}}) do
    LINE.user_unfollowed(user_id)
  end

  defp follow_message({:ok, %{language: "ja"} = line_user}) do
    [
      %{type: "text", text: line_user.display_name <> "様、友達になってくれてありがとうございます！"},
      %{type: "text", text: "自動翻訳の受信を開始するには、僕をグループ会話に追加してください。"}
    ]
  end

  defp follow_message({:ok, line_user}) do
    [
      %{type: "text", text: "Hello, " <> line_user.display_name <> "!"},
      %{
        type: "text",
        text:
          "Feel free to add me to a group conversation to start receiving automated translations!"
      }
    ]
  end
end
