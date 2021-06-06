defmodule Eddie.LINETest do
  use Eddie.DataCase

  alias Eddie.LINE

  describe "line_users" do
    alias Eddie.LINE.User

    @valid_attrs %{
      display_name: "Arthur Dent",
      language: "en",
      picture_url: "some picture_url",
      user_id: "user123"
    }
    @update_attrs %{
      display_name: "Marvin",
      language: "jp",
      picture_url: "some updated picture_url",
      user_id: "user123"
    }
    @invalid_attrs %{
      display_name: nil,
      followed_at: nil,
      language: nil,
      picture_url: nil,
      user_id: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LINE.user_followed()

      user
    end

    # test "list_line_users/0 returns all line_users" do
    #  user = user_fixture()
    #  assert LINE.list_line_users() == [user]
    # end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert LINE.get_user!(user.id) == user
    end

    test "get_user_by_user_id/1 returns user by user_id" do
      user = user_fixture()
      assert LINE.get_user_by_user_id(user.user_id) == user
    end

    test "user_followed/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = LINE.user_followed(@valid_attrs)
      assert user.display_name == "Arthur Dent"
      assert user.language == "en"
      assert user.picture_url == "some picture_url"
      assert user.user_id == "user123"
    end

    test "user_followed/1 will remove unfollowed_at value" do
      assert {:ok, %User{} = user} = LINE.user_followed(@valid_attrs)
      assert user.unfollowed_at == nil
      assert {:ok, %User{} = user} = LINE.user_unfollowed(user.user_id)
      refute user.unfollowed_at == nil
      assert {:ok, %User{} = user} = LINE.user_followed(@valid_attrs)
      assert user.unfollowed_at == nil
    end

    test "user_followed/1 will replace existing data for conflicting user_id" do
      assert {:ok, %User{} = user} = LINE.user_followed(@valid_attrs)
      assert user.display_name == "Arthur Dent"
      assert user.user_id == "user123"
      assert {:ok, %User{} = user} = LINE.user_followed(@update_attrs)
      assert user.display_name == "Marvin"
      assert user.user_id == "user123"
      assert length(LINE.list_line_users()) == 1
    end

    test "user_followed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LINE.user_followed(@invalid_attrs)
    end

    # test "update_user/2 with valid data updates the user" do
    #  user = user_fixture()
    #  assert {:ok, %User{} = user} = LINE.update_user(user, @update_attrs)
    #  assert user.display_name == "some updated display_name"
    #  assert user.followed_at == ~N[2011-05-18 15:01:01]
    #  assert user.language == "some updated language"
    #  assert user.picture_url == "some updated picture_url"
    #  assert user.unfollowed_at == ~N[2011-05-18 15:01:01]
    #  assert user.user_id == "some updated user_id"
    # end

    # test "update_user/2 with invalid data returns error changeset" do
    #  user = user_fixture()
    #  assert {:error, %Ecto.Changeset{}} = LINE.update_user(user, @invalid_attrs)
    #  assert user == LINE.get_user!(user.id)
    # end

    # test "change_user/1 returns a user changeset" do
    #  user = user_fixture()
    #  assert %Ecto.Changeset{} = LINE.change_user(user)
    # end
  end

  describe "group_chats" do
    alias Eddie.LINE.GroupChat

    @valid_attrs %{group_id: "some group_id"}
    @update_attrs %{group_id: "some updated group_id"}
    @invalid_attrs %{group_id: nil}

    def group_chat_fixture(attrs \\ %{}) do
      {:ok, group_chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LINE.create_group_chat()

      group_chat
    end

    test "list_group_chats/0 returns all group_chats" do
      group_chat = group_chat_fixture()
      assert LINE.list_group_chats() == [group_chat]
    end

    test "get_group_chat!/1 returns the group_chat with given id" do
      group_chat = group_chat_fixture()
      assert LINE.get_group_chat!(group_chat.id) == group_chat
    end

    test "create_group_chat/1 with valid data creates a group_chat" do
      assert {:ok, %GroupChat{} = group_chat} = LINE.create_group_chat(@valid_attrs)
      assert group_chat.group_id == "some group_id"
    end

    test "create_group_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LINE.create_group_chat(@invalid_attrs)
    end

    test "update_group_chat/2 with valid data updates the group_chat" do
      group_chat = group_chat_fixture()
      assert {:ok, %GroupChat{} = group_chat} = LINE.update_group_chat(group_chat, @update_attrs)
      assert group_chat.group_id == "some updated group_id"
    end

    test "update_group_chat/2 with invalid data returns error changeset" do
      group_chat = group_chat_fixture()
      assert {:error, %Ecto.Changeset{}} = LINE.update_group_chat(group_chat, @invalid_attrs)
      assert group_chat == LINE.get_group_chat!(group_chat.id)
    end

    test "delete_group_chat/1 deletes the group_chat" do
      group_chat = group_chat_fixture()
      assert {:ok, %GroupChat{}} = LINE.delete_group_chat(group_chat)
      assert_raise Ecto.NoResultsError, fn -> LINE.get_group_chat!(group_chat.id) end
    end

    test "change_group_chat/1 returns a group_chat changeset" do
      group_chat = group_chat_fixture()
      assert %Ecto.Changeset{} = LINE.change_group_chat(group_chat)
    end
  end
end
