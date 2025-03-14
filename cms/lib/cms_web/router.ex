defmodule CMSWeb.Router do
  use CMSWeb, :router
  
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CMSWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CMSWeb.Plugs.AuthPlug
  end
  
  # ... other pipeline definitions
  
  scope "/", CMSWeb do
    pipe_through :browser
    
    get "/", PageController, :home
    
    # Authentication routes
    get "/register", AuthController, :register
    post "/register", AuthController, :create_user
    get "/login", AuthController, :login
    post "/login", AuthController, :authenticate
    delete "/logout", AuthController, :logout
  end
  
  # Define routes that require authentication
  scope "/app", CMSWeb do
    pipe_through [:browser, :require_authenticated_user]
    
    # Protected routes
    get "/profile", ProfileController, :show
  end
  
  # Authentication plug
  defp require_authenticated_user(conn, _) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "You must be logged in to access this page.")
      |> Phoenix.Controller.redirect(to: ~p"/login")
      |> halt()
    end
  end
end