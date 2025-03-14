defmodule CmsWeb.AuthHTML do
  @moduledoc """
  HTML templates for authentication-related views.
  """
  use CmsWeb, :html
  
  embed_templates "auth_html/*"
end