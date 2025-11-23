
defmodule RidefastWeb.Auth.Guardian do
  use Guardian, otp_app: :ridefast

  alias Ridefast.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
