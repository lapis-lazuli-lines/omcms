defmodule CMSWeb.AuthController do
  use CMSWeb, :controller
  alias CMS.Accounts
  
  def register(conn, _params) do
    render(conn, :register)
  end
  
  def create_user(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.register_user(email, password) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully. Please log in.")
        |> redirect(to: ~p"/login")
      
      {:error, %{body: %{"error" => error}}} ->
        conn
        |> put_flash(:error, error)
        |> render(:register)
    end
  end
  
  def login(conn, _params) do
    render(conn, :login)
  end
  
  def authenticate(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.sign_in(email, password) do
      {:ok, %{"access_token" => token}} ->
        conn
        |> put_session(:user_token, token)
        |> put_flash(:info, "Successfully logged in.")
        |> redirect(to: ~p"/app/profile")
      
      {:error, %{body: %{"error" => error}}} ->
        conn
        |> put_flash(:error, error)
        |> render(:login)
    end
  end
  
  def logout(conn, _params) do
    conn
    |> delete_session(:user_token)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: ~p"/")
  end
end