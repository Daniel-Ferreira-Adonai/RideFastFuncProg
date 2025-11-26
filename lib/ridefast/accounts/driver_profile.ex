defmodule Ridefast.Accounts.DriverProfile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:driver_id, :id, autogenerate: false}
  schema "driver_profiles" do
    field :license_number, :string
    field :license_expiry, :date
    field :background_check_ok, :boolean

    belongs_to :driver, Ridefast.Accounts.Driver,
      define_field: false

    timestamps()
  end

  @doc false
  def changeset(driver_profile, attrs) do
    driver_profile
    |> cast(attrs, [
      :driver_id,
      :license_number,
      :license_expiry,
      :background_check_ok
    ])
    |> validate_required([
      :driver_id,
      :license_number,
      :license_expiry,
      :background_check_ok
    ])
     |> foreign_key_constraint(:driver_id, name: "driver_profiles_driver_id_fkey")
  |> unique_constraint(:driver_id, name: "PRIMARY")
  end
end
