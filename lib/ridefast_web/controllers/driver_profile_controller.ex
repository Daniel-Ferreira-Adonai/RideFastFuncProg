defmodule RidefastWeb.DriverProfileController do
  use RidefastWeb, :controller
  alias Ridefast.Accounts



def register(conn, %{"driver_id" => driver_id} = params) do
  profile_params =
    params
    |> Map.delete("driver_id")
    |> Map.put("driver_id", driver_id)

  case Accounts.create_driver_profile(profile_params) do
    {:ok, profile} ->
      conn
      |> put_status(:created)
      |> json(%{
        driver_id: profile.driver_id,
        license_number: profile.license_number,
        license_expiry: profile.license_expiry,
        background_check_ok: profile.background_check_ok
      })

      {:error, changeset} ->
        if Keyword.has_key?(changeset.errors, :driver_id) do
          conn
          |> put_status(:conflict)
          |> json(%{error: "Driver profile ja existe"})
        else
          conn
          |> put_status(:bad_request)
          |> json(%{errors: changeset.errors})
        end
    end
  end

    def show(conn, %{"driver_id" => id}) do
    case Accounts.get_driver_profile(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "driver not found"})

      user ->
        conn
        |> json(%{
         driver_id: user.driver_id,
          license_number: user.license_number,
          license_expiry: user.license_expiry,
          background_check_ok: user.background_check_ok
        })
    end
  end
   def update(conn, %{"driver_id" => id} = params) do

    case Accounts.update_driver_profile(id, params) do
      {:ok, user} ->
        json(conn, %{
          driver_id: id,
          license_number: user.license_number,
          license_expiry: user.license_expiry,
          background_check_ok: user.background_check_ok
        })

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset.errors})
    end
  end
end
