defmodule CMS.Accounts do
  @moduledoc """
  The Accounts context handles user authentication and profile management
  through Supabase integration.
  """
  
  alias CMS.Supabase
  
  def register_user(email, password) do
    Supabase.client()
    |> Req.post("/auth/v1/signup", json: %{
      email: email,
      password: password
    })
    |> handle_response()
  end
  
  def sign_in(email, password) do
    Supabase.client()
    |> Req.post("/auth/v1/token?grant_type=password", json: %{
      email: email,
      password: password
    })
    |> handle_response()
  end
  
  def get_user(access_token) do
    Supabase.client()
    |> Req.get("/auth/v1/user", headers: [
      {"Authorization", "Bearer #{access_token}"}
    ])
    |> handle_response()
  end
  
  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    {:ok, body}
  end
  
  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, %{status: status, body: body}}
  end
  
  defp handle_response({:error, _} = error) do
    error
  end
end