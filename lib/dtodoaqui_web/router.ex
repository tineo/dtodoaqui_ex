defmodule DtodoaquiWeb.Router do
  use DtodoaquiWeb, :router

  alias Dtodoaqui.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/", DtodoaquiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DtodoaquiWeb do
  #   pipe_through :api
  # end

  scope "/api", DtodoaquiWeb do
    pipe_through :api

    resources "/users", UserController#, only: [:create, :show]
    options   "/users", UserController, :options
    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
  end

  scope "/api", DtodoaquiWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my_user", UserController, :show
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :dtodoaqui, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Dtodoaqui"
      }
    }
  end

end
