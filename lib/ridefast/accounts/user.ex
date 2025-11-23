defmodule Ridefast.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password_hash, :string

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :phone, :password_hash])
    |> validate_required([:name, :email, :phone, :password_hash])
    |> unique_constraint(:email)
  end



end
