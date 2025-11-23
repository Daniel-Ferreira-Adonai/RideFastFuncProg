defmodule Ridefast.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :phone, :string
      add :password_hash, :string

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:users, [:email])
  end
end
