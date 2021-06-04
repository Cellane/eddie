defmodule Eddie.LINE.Handler.Follow do
  alias Eddie.LINE
  alias Eddie.LINE.API

  def follow(%{"source" => %{"type" => "user", "userId" => user_id}} = event) do
    {:ok, profile} = API.profile(user_id)
    LINE.user_followed(profile)
  end

  def unfollow(%{"source" => %{"type" => "user", "userId" => user_id}} = event) do
    LINE.user_unfollowed(user_id)
  end
end
