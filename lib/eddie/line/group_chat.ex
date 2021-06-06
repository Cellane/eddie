defmodule Eddie.LINE.GroupChat do
  use Ecto.Schema

  alias Eddie.LINE.GroupChat
  import Ecto.Changeset
  import Ecto.Query

  schema "group_chats" do
    field(:group_id, :string)
    field(:joined_at, :naive_datetime)
    field(:left_at, :naive_datetime)

    timestamps()
  end

  def by_group_id(group_id) do
    from(g in GroupChat, where: g.group_id == ^group_id)
  end

  @doc false
  def joined_changeset(group_chat) do
    group_chat
    |> change()
    |> validate_required([:group_id])
  end

  def left_changeset(group_chat, attrs) do
    group_chat
    |> cast(attrs, [:left_at])
    |> validate_required([:left_at])
  end
end
