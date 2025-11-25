defmodule Ridefast.Accounts.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drivers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password_hash, :string
    field :role, :string
    field :status, :string, default: "ACTIVE"
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :email, :phone, :password_hash, :status])
    |> validate_required([:name, :email, :phone, :password_hash, :status])
    |> validate_inclusion(:role, ["driver"])
    |> unique_constraint(:email)
  end
end
