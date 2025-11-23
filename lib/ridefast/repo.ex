defmodule Ridefast.Repo do
  use Ecto.Repo,
    otp_app: :ridefast,
    adapter: Ecto.Adapters.MyXQL
end
