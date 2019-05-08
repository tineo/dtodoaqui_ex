defmodule Dtodoaqui.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dtodoaqui.Accounts.User

  schema "directory_platform_users" do
    field :confirmation_token, :string
    field :created, :utc_datetime
    field :email, :string
    field :email_canonical, :string
    field :enabled, :boolean, default: false
    field :is_verified, :boolean, default: false
    field :last_login, :utc_datetime
    field :modified, :utc_datetime
    field :password, :string
    # Virtual fields:
    field :password_confirmation, :string, virtual: true
    field :password_requested_at, :utc_datetime
    field :roles, :string
    field :salt, :string
    field :username, :string
    field :username_canonical, :string

    timestamps()
  end

  #@doc false
  #def changeset(user, attrs) do
  #  user
  #  |> cast(attrs, [:username, :username_canonical, :email, :email_canonical, :enabled, :salt, :password, :last_login, :confirmation_token, :password_requested_at, :roles, :is_verified, :created, :modified])
  #  |> validate_required([:username, :username_canonical, :email, :email_canonical, :enabled, :salt, :password, :last_login, :confirmation_token, :password_requested_at, :roles, :is_verified, :created, :modified])
  #end
  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation]) # Remove hash, add pw + pw confirmation
    |> validate_required([:email, :password, :password_confirmation]) # Remove hash, add pw + pw confirmation
    |> validate_format(:email, ~r/@/) # Check that email is valid
    |> validate_length(:password, min: 8) # Check that password length is >= 8 
    |> validate_confirmation(:password) # Check that password === password_confirmation
    |> unique_constraint(:email)
    |> put_password_hash 
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}}
        ->
          put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
          changeset
    end
  end
end
