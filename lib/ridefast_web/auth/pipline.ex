defmodule RidefastWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ridefast,
    module: RidefastWeb.Auth.Guardian,
    error_handler: RidefastWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
