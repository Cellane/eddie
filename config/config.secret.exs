use Mix.Config

line_channel_access_token =
  System.get_env("LINE_CHANNEL_ACCESS_TOKEN") ||
    raise "environment variable LINE_CHANNEL_ACCESS_TOKEN is missing."

line_channel_secret =
  System.get_env("LINE_CHANNEL_SECRET") ||
    raise "environment variable LINE_CHANNEL_SECRET is missing."

config :eddie, :line,
  channel_access_token: line_channel_access_token,
  channel_secret: line_channel_secret
