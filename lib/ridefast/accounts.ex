defmodule Ridefast.Accounts do
alias Ridefast.Repo
alias Ridefast.Accounts.User
def create_user(attrs) do
    hashed_passawrod = Bcrypt.hash_pwd_salt(attrs["password"])

    attrs =
      attrs
      |> Map.put("password_hash", hashed_passawrod)
      |> Map.delete("password")

      %User{}
      |>User.changeset(attrs)
      |> Repo.insert()
  end
end
