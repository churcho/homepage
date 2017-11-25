defmodule HomepageWeb.SessionController do
  use HomepageWeb, :controller
  alias Homepage.User
  alias HomepageWeb.Helpers.UserSession

  def show_login(conn, _params) do
    # If already logged in, send to /home
    case UserSession.current_user(conn) do
      nil ->
        render conn, :login
      user ->
        redirect conn, to: "/home"
    end
  end

  def login(conn, %{ "email" => email, "password" => password }) do
    case conn |> UserSession.login(email, password) do
      {:ok, user, conn} ->
        conn |> redirect(to: "/home")
      {:error, reason} ->
        conn
          |> put_status(401)
          |> json(%{ error: true, messages: [reason] })
    end
  end

  def logout(conn, _params) do
    conn
      |> UserSession.logout
      |> redirect(to: "/")
  end

  def show_signup(conn, _params) do
    conn
      |> clear_flash
      |> render(:signup)
  end

  def signup(conn, %{ "email" => email, "password" => password }) do
    case conn |> UserSession.signup(email, password) do
      {:ok, user, conn} -> conn |> redirect(to: "/home")
      {:error, reason} ->
        conn
          |> put_flash(:error, "Failed to signup: #{reason}")
          |> render(:signup)
    end
  end
end
