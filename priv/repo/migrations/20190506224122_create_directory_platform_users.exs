defmodule Dtodoaqui.Repo.Migrations.CreateDirectoryPlatformUsers do
  use Ecto.Migration

  def change do
    create table(:directory_platform_users) do
      add :username, :string
      add :username_canonical, :string
      add :email, :string
      add :email_canonical, :string
      add :enabled, :boolean, default: false, null: false
      add :salt, :string
      add :password, :string
      add :last_login, :utc_datetime
      add :confirmation_token, :string
      add :password_requested_at, :utc_datetime
      add :roles, :string
      add :is_verified, :boolean, default: false, null: false
      add :created, :utc_datetime
      add :modified, :utc_datetime

      timestamps()
    end

  end
end
