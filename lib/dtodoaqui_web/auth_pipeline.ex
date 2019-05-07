defmodule Dtodoaqui.Guardian.AuthPipeline do
    use Guardian.Plug.Pipeline, otp_app: :dtodoaqui,
    module: Dtodoaqui.Guardian,
    error_handler: Dtodoaqui.AuthErrorHandler
  
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
end