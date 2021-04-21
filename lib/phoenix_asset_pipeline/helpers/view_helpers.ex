defmodule PhoenixAssetPipeline.ViewHelpers do
  @moduledoc """
  A helpers for serving static assets.

  Provides helpers for views

    * image_tag/3

    * style_tag/2

    * script_tag/3

  for phoenix_asset_pipeline assets

  ## Integrate in Phoenix
  The simplest way to add the helpers to Phoenix is a `import PhoenixAssetPipeline.ViewHelpers`
  either in your `my_app_web.ex` under views to have it available under every views,
  or under for example `App.LayoutView` to have it available in your layout.

    defmodule MyAppWeb do
      def view do
        quote do
          use Phoenix.View,
            root: "lib/my_app_web/templates",
            namespace: MyAppWeb

          # Import convenience functions from controllers
          import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

          # Include shared imports and aliases for views
          unquote(view_helpers())
        end
      end

      defp view_helpers do
        quote do
          # Use all HTML functionality (forms, tags, etc)
          use Phoenix.HTML

          import PhoenixAssetPipeline.ViewHelpers
        end
      end
    end
  """

  import Phoenix.HTML.Tag, only: [content_tag: 3, img_tag: 2]
  alias PhoenixAssetPipeline.Pipelines.{CoffeeScript, Sass}
  alias Plug.Conn

  @assets_url Application.compile_env(:phoenix_asset_pipeline, :assets_url)

  def base_url(conn) do
    @assets_url || "#{conn.scheme}://#{conn.host}:4001"
  end

  def image_tag(_, _, _ \\ [])

  def image_tag(%Conn{} = conn, path, opts) do
    image_tag(base_url(conn), path, opts)
  end

  def image_tag(assets_url, path, opts) do
    img_tag("#{assets_url}/img/#{path}", opts)
  end

  def script_tag(_, _, _ \\ [])

  def script_tag(%Conn{} = conn, path, opts) do
    script_tag(base_url(conn), path, opts)
  end

  def script_tag(assets_url, path, opts) do
    {_, digest, integrity} = CoffeeScript.new(path)

    opts =
      opts
      |> Keyword.put_new(:integrity, "sha384-" <> integrity)
      |> Keyword.put_new(:src, "#{assets_url}/js/#{path}-#{digest}.js")

    content_tag(:script, "", opts)
  end

  def style_tag(path, opts \\ []) do
    content_tag(:style, {:safe, Sass.new(path)}, opts)
  end
end
