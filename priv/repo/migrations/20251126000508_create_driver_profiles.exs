defmodule Ridefast.Repo.Migrations.CreateDriverProfiles do
  use Ecto.Migration

 def change do
  create table(:driver_profiles, primary_key: false) do
    add :driver_id,
      references(:drivers, on_delete: :delete_all),
      primary_key: true

    add :license_number, :string
    add :license_expiry, :date
    add :background_check_ok, :boolean

    timestamps()
  end

  create unique_index(:driver_profiles, [:driver_id])
end

end
