# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dtodoaqui,
  ecto_repos: [Dtodoaqui.Repo]

# Configures the endpoint
config :dtodoaqui, DtodoaquiWeb.Endpoint,
  url: [host: "0.0.0.0"],
  secret_key_base: "466vwXj5D505neh33WNKFuG4UEAklQ9+Wf7XNda0VFfmYJobJOVG6tDmqtn7XNB7",
  render_errors: [view: DtodoaquiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Dtodoaqui.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


config :dtodoaqui, Dtodoaqui.Guardian,
  issuer: "dtodoaqui",
  secret_key: "2gSG40Pws6bjCTBnVegUsx2DXB3rm9KD/6ebCsbCSD/tre2OI/f4nMxR0teWVYjs"

config :dtodoaqui, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: DtodoaquiWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: DtodoaquiWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }
