defmodule RidefastWeb.AuthController do
  use RidefastWeb, :controller
  alias Ridefast.Accounts
  alias RidefastWeb.Auth.Guardian

  def register(conn, %{"role" => role} = params) do
    case role do
      "user" ->
        register_user(conn, params)

      "admin" ->
        register_user(conn, params)

      "driver" ->
        register_driver(conn, params)

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid role, must be 'user' or 'driver'"})
    end
  end

  def register_user(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          id: user.id,
          name: user.name,
          email: user.email
        })

      {:error, changeset} ->
        if Keyword.has_key?(changeset.errors, :email) do
          conn
          |> put_status(:conflict)
          |> json(%{error: "Email already registered"})
        else
          conn
          |> put_status(:bad_request)
          |> json(%{errors: changeset.errors})
        end
    end
  end

  def register_driver(conn, params) do
    case Accounts.create_driver(params) do
      {:ok, driver} ->
        conn
        |> put_status(:created)
        |> json(%{
          id: driver.id,
          name: driver.name,
          email: driver.email,
          phone: driver.phone,
          status: driver.status,
          role: driver.role
        })

      {:error, changeset} ->
        if Keyword.has_key?(changeset.errors, :email) do
          conn
          
          |> put_status(:conflict)
          |> json(%{error: "Email already registered"})
        else
          conn
          |> put_status(:bad_request)
          |> json(%{errors: changeset.errors})
        end
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:ok)
        |> json(%{
          token: token,
          expires_in: claims["exp"],
          user: %{
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role
          }
        })

      {:error, :unauthorized} ->
        case Accounts.authenticate_driver(email, password) do
          {:ok, user} ->
            {:ok, token, claims} = Guardian.encode_and_sign(user)

            conn
            |> put_status(:ok)
            |> json(%{
              token: token,
              expires_in: claims["exp"],
              user: %{
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role
              }
            })

          {:error, :unauthorized} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid email or password"})
        end
    end
  end

  def login(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Email and password required"})
  end
end
