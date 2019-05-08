defmodule DtodoaquiWeb.UserController do
  use DtodoaquiWeb, :controller
  use PhoenixSwagger

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

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the app")

          properties do
            id(:integer, "User ID")
            name(:string, "User name", required: true)
            email(:string, "Email address", format: :email, required: true)
            inserted_at(:string, "Creation timestamp", format: :datetime)
            updated_at(:string, "Update timestamp", format: :datetime)
          end

          example(%{
            id: 123,
            name: "Joe",
            email: "joe@gmail.com"
          })
        end,
      UserRequest:
        swagger_schema do
          title("UserRequest")
          description("POST body for creating a user")
          property(:user, Schema.ref(:User), "The user details")
        end,
      UserResponse:
        swagger_schema do
          title("UserResponse")
          description("Response schema for single user")
          property(:data, Schema.ref(:User), "The user details")
        end,
      UsersResponse:
        swagger_schema do
          title("UsersReponse")
          description("Response schema for multiple users")
          property(:data, Schema.array(:User), "The users details")
        end
    }
  end

  swagger_path(:index) do
    get("/api/users")
    summary("List Users")
    description("List all users in the database")
    produces("application/json")
    deprecated(false)

    response(200, "OK", Schema.ref(:UsersResponse),
      example: %{
        data: [
          %{
            id: 1,
            name: "Joe",
            email: "Joe6@mail.com",
            inserted_at: "2017-02-08T12:34:55Z",
            updated_at: "2017-02-12T13:45:23Z"
          },
          %{
            id: 2,
            name: "Jack",
            email: "Jack7@mail.com",
            inserted_at: "2017-02-04T11:24:45Z",
            updated_at: "2017-02-15T23:15:43Z"
          }
        ]
      }
    )
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
