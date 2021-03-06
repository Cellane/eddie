# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :eddie,
  ecto_repos: [Eddie.Repo]

# Configures the endpoint
config :eddie, EddieWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6AfYABCwo45kEbNJoFd6OUgb3NjXMB4xfKxyXlpIxO/J8+GUtNTADkduPTwC1np8",
  render_errors: [view: EddieWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Eddie.PubSub,
  live_view: [signing_salt: "mt/JQ3+9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "config.secret.exs"
