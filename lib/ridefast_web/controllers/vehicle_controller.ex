defmodule RidefastWeb.VehicleController do
  use RidefastWeb, :controller

  alias Ridefast.Accounts

def register(conn, %{"driver_id" => driver_id} = params) do

  vehicles_params =
    params
    |> Map.put("driver_id", driver_id)
   case Accounts.create_vehicle(vehicles_params) do
    {:ok, vehicle} ->
      conn
      |> put_status(:created)
      |> json(%{
        id: vehicle.id,
        driver_id: vehicle.driver_id,
        plate: vehicle.plate,
        model: vehicle.model,
        color: vehicle.color,
        seats: vehicle.seats,
        active: vehicle.active
      })

      {:error, changeset} ->
          conn
          |> put_status(:bad_request)
          |> json(%{errors: changeset.errors})

    end
  end


  def show(conn, %{"driver_id" => driver_id}) do
    case Accounts.get_driver_vehicles(driver_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

     vehicles ->
      json(conn, %{
        vehicles:
          Enum.map(vehicles, fn vehicle ->
            %{
              id: vehicle.id,
              driver_id: vehicle.driver_id,
              plate: vehicle.plate,
              model: vehicle.model,
              color: vehicle.color,
              seats: vehicle.seats,
              active: vehicle.active
            }
          end)
      })
  end
  end



  def update(conn, %{"id" => id} = params) do
    cleaned_params =
      params
      |> Map.drop(["id"])

    case Accounts.update_vehicle(id, cleaned_params) do
      {:ok, vehicle} ->
        json(conn, %{
          id: vehicle.id,
        driver_id: vehicle.driver_id,
        plate: vehicle.plate,
        model: vehicle.model,
        color: vehicle.color,
        seats: vehicle.seats,
        active: vehicle.active
        })

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset.errors})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.delete_vehicle(id) do
      {:ok, _user} ->
        conn
        |> send_resp(:no_content, "")

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "vehicle not found"})
    end
  end
end
