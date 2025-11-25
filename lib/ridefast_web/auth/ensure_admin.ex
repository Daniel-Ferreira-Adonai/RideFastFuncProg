defmodule RidefastWeb.Auth.EnsureAdmin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.current_claims(conn) do
      %{"role" => "admin"} ->
        conn

      _ ->
        conn
        |> put_status(:forbidden)
        |> json(%{
          error: "Access denied: admin only."
        })
        |> halt()
    end
  end
end
