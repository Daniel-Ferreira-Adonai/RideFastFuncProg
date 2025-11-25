defmodule RidefastWeb.Router do
  alias OpenApiSpex.Plug.{SwaggerUI, RenderSpec}

  use RidefastWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end
    pipeline :auth do
    plug RidefastWeb.Auth.Pipeline
  end
  scope "/api/v1", RidefastWeb do
  pipe_through [:api, :auth, RidefastWeb.Auth.EnsureAdmin]
  post "/drivers", AuthController, :register
  post "/users", AuthController, :register

  get "/users", UserController, :index
  get "/drivers", DriverController, :index
end

  scope "/api/v1", RidefastWeb do
  pipe_through [:api, :auth, RidefastWeb.Auth.EnsureSelfOrAdmin]

  put "/users/:id", UserController, :update
  get "/users/:id", UserController, :show
  delete "/users/:id", UserController, :delete
  put "/drivers/:id", DriverController, :update
  get "/drivers/:id", DriverController, :show
  delete "/drivers/:id", DriverController, :delete
end

#para rotas publicas
  scope "/api/v1", RidefastWeb do
  pipe_through :api

  post "/auth/login", AuthController, :login
  post "/auth/register", AuthController, :register
end
#rotas fechadas
scope "/api/v1", RidefastWeb do
  pipe_through [:api, :auth] # <- olha o auth aq

  #get "/users/me", UserController, :me
end
  scope "/api", RidefastWeb do
  options "/*path", RidefastWeb.CORSController, :options

    # post "v1/auth/register", UserController, :register
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ridefast, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RidefastWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
