defmodule RidefastWeb.AuthController do
  use RidefastWeb, :controller
  alias Ridefast.Accounts


  def register(conn, %{"role" => role} = params) do
  case role do
    "user" ->
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
          conn
          |> put_status(:bad_request)
          |> json(%{
            errors: changeset.errors
          })
    end



  end

  def register_driver(conn, _params) do
    #deve conter função register driver

  end



end
