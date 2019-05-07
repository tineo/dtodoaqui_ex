defmodule DtodoaquiWeb.UserControllerTest do
  use DtodoaquiWeb.ConnCase

  alias Dtodoaqui.Accounts
  alias Dtodoaqui.Accounts.User

  @create_attrs %{
    confirmation_token: "some confirmation_token",
    created: "2010-04-17T14:00:00Z",
    email: "some email",
    email_canonical: "some email_canonical",
    enabled: true,
    is_verified: true,
    last_login: "2010-04-17T14:00:00Z",
    modified: "2010-04-17T14:00:00Z",
    password: "some password",
    password_requested_at: "2010-04-17T14:00:00Z",
    roles: "some roles",
    salt: "some salt",
    username: "some username",
    username_canonical: "some username_canonical"
  }
  @update_attrs %{
    confirmation_token: "some updated confirmation_token",
    created: "2011-05-18T15:01:01Z",
    email: "some updated email",
    email_canonical: "some updated email_canonical",
    enabled: false,
    is_verified: false,
    last_login: "2011-05-18T15:01:01Z",
    modified: "2011-05-18T15:01:01Z",
    password: "some updated password",
    password_requested_at: "2011-05-18T15:01:01Z",
    roles: "some updated roles",
    salt: "some updated salt",
    username: "some updated username",
    username_canonical: "some updated username_canonical"
  }
  @invalid_attrs %{confirmation_token: nil, created: nil, email: nil, email_canonical: nil, enabled: nil, is_verified: nil, last_login: nil, modified: nil, password: nil, password_requested_at: nil, roles: nil, salt: nil, username: nil, username_canonical: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all directory_platform_users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "confirmation_token" => "some confirmation_token",
               "created" => "2010-04-17T14:00:00Z",
               "email" => "some email",
               "email_canonical" => "some email_canonical",
               "enabled" => true,
               "is_verified" => true,
               "last_login" => "2010-04-17T14:00:00Z",
               "modified" => "2010-04-17T14:00:00Z",
               "password" => "some password",
               "password_requested_at" => "2010-04-17T14:00:00Z",
               "roles" => "some roles",
               "salt" => "some salt",
               "username" => "some username",
               "username_canonical" => "some username_canonical"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "confirmation_token" => "some updated confirmation_token",
               "created" => "2011-05-18T15:01:01Z",
               "email" => "some updated email",
               "email_canonical" => "some updated email_canonical",
               "enabled" => false,
               "is_verified" => false,
               "last_login" => "2011-05-18T15:01:01Z",
               "modified" => "2011-05-18T15:01:01Z",
               "password" => "some updated password",
               "password_requested_at" => "2011-05-18T15:01:01Z",
               "roles" => "some updated roles",
               "salt" => "some updated salt",
               "username" => "some updated username",
               "username_canonical" => "some updated username_canonical"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
