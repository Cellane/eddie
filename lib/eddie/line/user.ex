defmodule Eddie.LINE.User do
  use Ecto.Schema

  alias Eddie.LINE.User
  import Ecto.Changeset
  import Ecto.Query

  schema "line_users" do
    field(:display_name, :string)
    field(:followed_at, :naive_datetime)
    field(:language, :string)
    field(:picture_url, :string)
    field(:unfollowed_at, :naive_datetime)
    field(:user_id, :string)

    timestamps()
  end

  def by_user_id(user_id) do
    from(u in User, where: u.user_id == ^user_id)
  end

  @doc false
  def followed_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :user_id,
      :display_name,
      :picture_url,
      :language,
      :followed_at,
      :unfollowed_at
    ])
    |> validate_required([:user_id, :display_name, :language, :followed_at])
  end

  def unfollowed_changeset(user, attrs) do
    user
    |> cast(attrs, [:unfollowed_at])
    |> validate_required([:unfollowed_at])
  end
end
