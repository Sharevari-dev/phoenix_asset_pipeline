defmodule PhoenixAssetPipeline.Plugs.JavaScript do
  @moduledoc false

  use Plug.ErrorHandler

  import Plug.Conn
  alias PhoenixAssetPipeline.Pipelines

  @allowed_methods ~w(GET HEAD)

  defmodule InvalidPathError do
    defexception message: "invalid path for javascript", plug_status: 400
  end

  def init(opts), do: opts

  def call(%{method: method, path_info: ["js" | segments]} = conn, _opts)
      when method in @allowed_methods do
    case Regex.named_captures(~r/(?<path>.*)-.{32}\.js$/, Enum.join(segments, "/")) do
      %{"path" => path} ->
        {js, _digest, _integrity} = Pipelines.CoffeeScript.new(path)

        conn
        |> put_resp_content_type("application/javascript")
        |> put_resp_header("accept-ranges", "bytes")
        |> put_resp_header("access-control-allow-origin", "*")
        |> put_resp_header("vary", "accept-encoding")
        |> send_resp(200, js)
        |> halt()

      _ ->
        raise InvalidPathError
    end
  end

  def call(conn, _opts), do: conn

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    message =
      case reason do
        %{action: _action, path: _path, reason: :enoent} -> File.Error.message(reason)
        %{message: message, plug_status: _status} -> message
      end

    conn
    |> send_resp(conn.status, message)
    |> halt()
  end
end
