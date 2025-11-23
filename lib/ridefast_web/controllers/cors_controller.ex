defmodule RidefastWeb.CORSController do
  use RidefastWeb, :controller

  def options(conn, _params) do
    send_resp(conn, 204, "")
  end
end
