defmodule Ridefast.Accounts do
  alias Ridefast.Repo
  alias Ridefast.Accounts.User
  alias Ridefast.Accounts.Driver

  import Ecto.Query

  def create_user(attrs) do
    hashed_passawrod = Bcrypt.hash_pwd_salt(attrs["password"])

    attrs =
      attrs
      |> Map.put("password_hash", hashed_passawrod)
      |> Map.delete("password")

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_driver(attrs) do
    hashed_passawrod = Bcrypt.hash_pwd_salt(attrs["password"])

    attrs =
      attrs
      |> Map.put("password_hash", hashed_passawrod)
      |> Map.delete("password")

    %Driver{}
    |> Driver.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_driver_by_email(email) do
    Repo.get_by(Driver, email: email)
  end

  def authenticate_driver(email, password) do
    case get_driver_by_email(email) do
      nil ->
        {:error, :unauthorized}

      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil ->
        {:error, :unauthorized}

      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end

  def list_users do
    Repo.all(User)
  end
  def list_drivers do
    Repo.all(Drivers)
  end
  def get_user(id), do: Repo.get(User, id)
  def get_driver(id), do: Repo.get(Driver, id)

  def paginate_users(page, size) do
    offset = (page - 1) * size

    Repo.all(
      from u in User,
        limit: ^size,
        offset: ^offset
    )
  end
   def paginate_drivers(page, size) do
    offset = (page - 1) * size

    Repo.all(
      from u in Driver,
        limit: ^size,
        offset: ^offset
    )
  end

  def update_user(id, attrs) do
    user = Repo.get(User, id)

    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
   def update_driver(id, attrs) do
    user = Repo.get(Driver, id)

    user
    |> Driver.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(id) do
    case Repo.get(User, id) do
      nil ->
        {:error, :not_found}

      user ->
        Repo.delete(user)
    end
  end
  def delete_driver(id) do
    case Repo.get(Driver, id) do
      nil ->
        {:error, :not_found}

      user ->
        Repo.delete(user)
    end
  end
end
