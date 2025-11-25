defmodule RidefastWeb.UserController do
  use RidefastWeb, :controller

  alias Ridefast.Accounts

  def show(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        conn
        |> json(%{
          id: user.id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          created_at: user.created_at
        })
    end
  end

  def index(conn, %{"page" => page, "size" => size}) do
    page = String.to_integer(page)
    size = String.to_integer(size)
    users = Accounts.paginate_users(page, size)

    json(conn, %{
      users:
        Enum.map(users, fn user ->
          %{
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            role: user.role,
            created_at: user.created_at
          }
        end)
    })
  end

  def update(conn, %{"id" => id} = params) do
    cleaned_params =
      params
      |> Map.drop(["id", "created_at", "role"])

    case Accounts.update_user(id, cleaned_params) do
      {:ok, user} ->
        json(conn, %{
          id: user.id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          created_at: user.created_at
        })

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset.errors})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.delete_user(id) do
      {:ok, _user} ->
        conn
        |> send_resp(:no_content, "")

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end
end
