defmodule Eddie.Repo.Migrations.CreateLineUsers do
  use Ecto.Migration

  def change do
    create table(:line_users) do
      add(:user_id, :string, null: false)
      add(:display_name, :string, null: false)
      add(:picture_url, :string)
      add(:language, :string, null: false)
      add(:followed_at, :naive_datetime, null: false)
      add(:unfollowed_at, :naive_datetime)

      timestamps()
    end

    create(unique_index(:line_users, [:user_id]))
  end
end
