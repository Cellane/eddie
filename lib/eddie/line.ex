defmodule Eddie.LINE do
  @moduledoc """
  The LINE context.
  """

  import Ecto.Query, warn: false
  alias Eddie.Repo

  alias Eddie.LINE.GroupChat
  alias Eddie.LINE.User

  @doc """
  Returns the list of line_users.

  ## Examples

      iex> list_line_users()
      [%User{}, ...]

  """
  def list_line_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_user_id(user_id) do
    User.by_user_id(user_id)
    |> Repo.one()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert(
      on_conflict:
        {:replace,
         attrs
         |> Map.keys()
         |> Enum.map(&String.to_atom/1)
         |> Enum.reject(&(&1 == :user_id))},
      conflict_target: :user_id
    )
  end

  def user_followed(attrs \\ %{}) do
    %User{followed_at: now(), unfollowed_at: nil}
    |> User.followed_changeset(attrs)
    |> Repo.insert(
      on_conflict:
        {:replace, [:display_name, :picture_url, :language, :followed_at, :unfollowed_at]},
      conflict_target: :user_id
    )
  end

  def user_unfollowed(user_id) do
    get_user_by_user_id(user_id)
    |> User.unfollowed_changeset(%{unfollowed_at: now()})
    |> Repo.update()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defp now(), do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

  @doc """
  Returns the list of group_chats.

  ## Examples

      iex> list_group_chats()
      [%GroupChat{}, ...]

  """
  def list_group_chats do
    Repo.all(GroupChat)
  end

  @doc """
  Gets a single group_chat.

  Raises `Ecto.NoResultsError` if the Group chat does not exist.

  ## Examples

      iex> get_group_chat!(123)
      %GroupChat{}

      iex> get_group_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_chat!(id), do: Repo.get!(GroupChat, id)

  def get_group_chat_by_group_id(group_id) do
    GroupChat.by_group_id(group_id)
    |> Repo.one()
  end

  @doc """
  Creates a group_chat.

  ## Examples

      iex> create_group_chat(%{field: value})
      {:ok, %GroupChat{}}

      iex> create_group_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def group_chat_joined(group_id) do
    %GroupChat{group_id: group_id, joined_at: now(), left_at: nil}
    |> GroupChat.joined_changeset()
    |> Repo.insert(
      on_conflict: {:replace, [:joined_at, :left_at]},
      conflict_target: :group_id
    )
  end

  def group_chat_left(group_id) do
    get_group_chat_by_group_id(group_id)
    |> GroupChat.left_changeset(%{left_at: now()})
    |> Repo.update()
  end

  @doc """
  Updates a group_chat.

  ## Examples

      iex> update_group_chat(group_chat, %{field: new_value})
      {:ok, %GroupChat{}}

      iex> update_group_chat(group_chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_chat(%GroupChat{} = group_chat, attrs) do
    group_chat
    |> GroupChat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_chat changes.

  ## Examples

      iex> change_group_chat(group_chat)
      %Ecto.Changeset{data: %GroupChat{}}

  """
  def change_group_chat(%GroupChat{} = group_chat, attrs \\ %{}) do
    GroupChat.changeset(group_chat, attrs)
  end
end
