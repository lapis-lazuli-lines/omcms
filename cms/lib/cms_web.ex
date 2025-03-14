defmodule CmsWeb do
  @moduledoc """
  Web-related module for defining Phoenix application interfaces.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: CmsWeb.Layouts]

      import Plug.Conn
      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component
      import Phoenix.HTML
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: CmsWeb.Endpoint,
        router: CmsWeb.Router,
        statics: CmsWeb.static_paths()
    end
  end

  @doc """
  Macro to dispatch to appropriate web interface components.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end