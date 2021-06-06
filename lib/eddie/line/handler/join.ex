defmodule Eddie.LINE.Handler.Join do
  alias Eddie.LINE
  alias Eddie.LINE.API

  def join(%{"replyToken" => reply_token, "source" => %{"type" => "group", "groupId" => group_id}}) do
    LINE.group_chat_joined(group_id)
    |> welcome_message()
    |> API.send_reply(reply_token)
  end

  def leave(%{"source" => %{"type" => "group", "groupId" => group_id}}) do
    LINE.group_chat_left(group_id)
  end

  defp welcome_message({:ok, _}) do
    [
      %{
        type: "text",
        text:
          "Hello there! You all look lovely today, and I’m thrilled to start translating messages in this group chat!"
      },
      %{
        type: "text",
        text: """
        To get started, I need to know a bit more about you all. Please tell me which language you’ll be WRITING in: user one, go!

        You can either use the quick reply buttons below, or type one of the supported languages by name.

        I currently support these languages:\
        """
      },
      %{
        type: "text",
        text: language_list(),
        quickReply: language_buttons()
      }
    ]
  end

  defp language_list() do
    Eddie.DeepL.Language.list_names()
    |> Enum.map(fn name -> "• " <> name end)
    |> Enum.join("\n")
  end

  defp language_buttons() do
    %{
      items:
        Eddie.DeepL.Language.list_popular()
        |> Enum.map(fn language ->
          %{
            type: "action",
            action: %{
              type: "message",
              label: language.name,
              text: language.name
            }
          }
        end)
    }
  end
end
