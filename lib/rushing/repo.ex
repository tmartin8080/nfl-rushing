defmodule Rushing.Repo do
  use Ecto.Repo,
    otp_app: :rushing,
    adapter: Ecto.Adapters.Postgres
end
