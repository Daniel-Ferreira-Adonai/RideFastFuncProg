defmodule RidefastWeb.Auth.EnsureSelfOrAdmin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    requested_id = conn.params["id"]

    cond do
      current_user.role == "admin" ->
        conn

      Integer.to_string(current_user.id) == requested_id ->
        conn

      true ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Not allowed"})
        |> halt()
    end
  end
end
