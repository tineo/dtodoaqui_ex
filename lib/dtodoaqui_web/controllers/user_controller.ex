defmodule DtodoaquiWeb.UserController do
  use DtodoaquiWeb, :controller

  alias Dtodoaqui.Accounts
  alias Dtodoaqui.Accounts.User

  alias Dtodoaqui.Guardian

  action_fallback DtodoaquiWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def index(conn, _params) do
    directory_platform_users = Accounts.list_directory_platform_users()
    render(conn, "index.json", directory_platform_users: directory_platform_users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      #conn
      #|> put_status(:created)
      #|> put_resp_header("location", Routes.user_path(conn, :show, user))
      #|> render("show.json", user: user)
      conn |> render("jwt.json", jwt: token)
    end
  end

  #def show(conn, %{"id" => id}) do
  #  user = Accounts.get_user!(id)
  #  render(conn, "show.json", user: user)
  #end
  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
