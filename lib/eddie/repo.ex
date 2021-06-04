defmodule Eddie.Repo do
  use Ecto.Repo,
    otp_app: :eddie,
    adapter: Ecto.Adapters.Postgres
end
