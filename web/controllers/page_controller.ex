defmodule Mud.PageController do
  use Mud.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
