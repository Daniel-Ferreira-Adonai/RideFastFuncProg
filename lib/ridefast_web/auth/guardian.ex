defmodule RidefastWeb.Auth.Guardian do
  use Guardian, otp_app: :ridefast

  alias Ridefast.Accounts

  @impl true
  def subject_for_token(user, _claims) do
    {:ok, user.id |> to_string()}
  end

  @impl true
  def build_claims(claims, user, _opts) do
    {:ok, Map.put(claims, "role", user.role)}
  end

  @impl true
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
