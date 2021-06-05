defmodule Eddie.LINE do
  @moduledoc """
  The LINE context.
  """

  import Ecto.Query, warn: false
  alias Eddie.Repo

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
end
