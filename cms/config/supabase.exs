import Config

defmodule CMS.Supabase do
  def config do
    %{
      url: System.get_env("SUPABASE_URL"),
      api_key: System.get_env("SUPABASE_API_KEY"),
      jwt_secret: System.get_env("SUPABASE_JWT_SECRET")
    }
  end
  
  def client do
    config = config()
    fn ->
      %{
        base_url: config.url,
        headers: [
          {"apikey", config.api_key},
          {"Content-Type", "application/json"}
        ]
      }
    end
  end
end