defmodule DtodoaquiWeb.PageController do
  use DtodoaquiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
