defmodule Eddie.Repo.Migrations.CreateGroupChats do
  use Ecto.Migration

  def change do
    create table(:group_chats) do
      add(:group_id, :string, null: false)
      add(:joined_at, :naive_datetime, null: false)
      add(:left_at, :naive_datetime)

      timestamps()
    end

    create(unique_index(:group_chats, [:group_id]))
  end
end
