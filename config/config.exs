# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ridefast,
  ecto_repos: [Ridefast.Repo],
  generators: [timestamp_type: :utc_datetime]

  config :ridefast, RidefastWeb.Auth.Guardian,
  issuer: "ridefast",
  secret_key: "cMphaP9wY7f7h5o6plB4kDpVUxji8HHJM_U8ENou_deBncz6vl94A-aqN1FURgXT",
  ttl: {1, :hour}

# Configures the endpoint
config :ridefast, RidefastWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: RidefastWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Ridefast.PubSub,
  live_view: [signing_salt: "aSIovpas"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ridefast, Ridefast.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
