defmodule PhoenixAssetPipeline.Plug.Assets do
  @moduledoc false

  import Plug.Conn
  import PhoenixAssetPipeline.ViewHelpers

  def put_assets_url(conn, _params) do
    put_session(conn, :assets_url, base_url(conn))
  end
end
