defmodule PhoenixAssetPipeline.Plug.Static do
  @moduledoc false

  def init(opts), do: config(opts)

  def call(conn, opts) do
    Plug.Static.call(conn, Plug.Static.init(opts))
  end

  defp config(opts) do
    [
      at: Keyword.get(opts, :at, "/"),
      brotli: true,
      from: Keyword.get(opts, :from, "priv/static"),
      gzip: true
    ]
  end
end
