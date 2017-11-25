defmodule HomepageWeb.HomeController do
  use HomepageWeb, :controller
  alias Homepage.Servers.SessionServer

  def index(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        render conn, :index
      user_id ->
        user = Homepage.Repo.get(Homepage.User, user_id)
        redirect conn, to: "/home/#{user.email}"
    end
  end

  def show(conn, %{"messenger" => messenger}) do
    render conn, :show, messenger: messenger, user: SessionServer.current_user(conn)
  end
end
