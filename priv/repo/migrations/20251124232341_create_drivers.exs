defmodule Ridefast.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :name, :string
      add :email, :string
      add :phone, :string
      add :password_hash, :string
      add :role, :string
      add :status, :string, default: "ACTIVE"
    timestamps(inserted_at: :created_at)
    end

    create unique_index(:drivers, [:email])
  end
end
