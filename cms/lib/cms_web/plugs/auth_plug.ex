defmodule CmsWeb.Plugs.AuthPlug do
  import Plug.Conn
  alias CMS.Accounts
  
  def init(opts), do: opts
  
  def call(conn, _opts) do
    case get_auth_token(conn) do
      nil ->
        assign(conn, :current_user, nil)
      token ->
        case Accounts.get_user(token) do
          {:ok, user} ->
            assign(conn, :current_user, user)
          {:error, _} ->
            conn
            |> delete_session(:user_token)
            |> assign(:current_user, nil)
        end
    end
  end
  
  defp get_auth_token(conn) do
    get_session(conn, :user_token)
  end
end