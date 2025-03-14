import Config

config :cms, CMS.Repo,
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  socket_options: [:inet6],
  pool_size: 10 

defmodule CMS.Supabase do
  def config do
    %{
      url: System.get_env("SUPABASE_URL"),
      api_key: System.get_env("SUPABASE_API_KEY"),
      jwt_secret: System.get_env("SUPABASE_JWT_SECRET")
    }
  end
  
  def client do
    Req.new(
      base_url: config().url,
      headers: [
        {"apikey", config().api_key},
        {"Content-Type", "application/json"}
      ]
    )
  end
end