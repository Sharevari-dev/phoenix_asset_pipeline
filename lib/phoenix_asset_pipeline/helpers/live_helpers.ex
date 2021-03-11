defmodule PhoenixAssetPipeline.LiveHelpers do
  @moduledoc false

  import Phoenix.LiveView

  def assign_assets_url(socket, %{"assets_url" => assets_url}) do
    assign_new(socket, :assets_url, fn -> assets_url end)
  end

  def assign_assets_url(socket, _session), do: socket
end
