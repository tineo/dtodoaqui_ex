defmodule DtodoaquiWeb.UserView do
  use DtodoaquiWeb, :view
  alias DtodoaquiWeb.UserView

  def render("index.json", %{directory_platform_users: directory_platform_users}) do
    %{data: render_many(directory_platform_users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      username_canonical: user.username_canonical,
      email: user.email,
      email_canonical: user.email_canonical,
      enabled: user.enabled,
      salt: user.salt,
      password: user.password,
      last_login: user.last_login,
      confirmation_token: user.confirmation_token,
      password_requested_at: user.password_requested_at,
      roles: user.roles,
      is_verified: user.is_verified,
      created: user.created,
      modified: user.modified}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
