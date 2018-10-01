defmodule ExJsonLogger.Plug.Logger do
  @moduledoc """
  A plug for logging request information through metadata.

  Logger Metadata avaliable:
   * method - request method
   * path - request path
   * status - request status (integer)
   * duration - time in milliseconds from connection to response (float)
   * format - (phoenix specific)
   * controller - (phoenix specific)
   * action - (phoenix specific)

  Metadata is filtered by default so keys will need to be whitelisted.

  ## Usage

  To use with a Phoenix application, replace `plug Plug.Logger` in the projects endpoint.ex file with `ExJsonLogger.Plug.Logger`:

      # plug Plug.Logger
      plug ExJsonLogger.Plug.Logger

  ## Options
  * `:log` - The log level at which this plug should log its request info.
  Default is `:info`.
  """

  require Logger
  alias Plug.Conn
  @behaviour Plug

  @spec init(Keyword.t()) :: Logger.level()
  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  @spec call(Conn.t(), Logger.level()) :: Conn.t()
  def call(conn, level) do
    start_time = current_time()

    Conn.register_before_send(conn, fn conn ->
      stop_time = current_time()
      diff = stop_time - start_time
      duration = System.convert_time_unit(diff, :native, :microsecond) / 1000

      metadata =
        []
        |> Keyword.put(:method, conn.method)
        |> Keyword.put(:path, conn.request_path)
        |> Keyword.put(:status, conn.status)
        |> Keyword.put(:duration, duration)
        |> Keyword.merge(formatted_phoenix_info(conn))

      Logger.log(level, fn -> {"", metadata} end)

      conn
    end)
  end

  defp formatted_phoenix_info(%{
         private: %{
           phoenix_format: format,
           phoenix_controller: controller,
           phoenix_action: action
         }
       }) do
    [
      {:format, format},
      {:controller, inspect(controller)},
      {:action, Atom.to_string(action)}
    ]
  end

  defp formatted_phoenix_info(_), do: []

  defp current_time, do: System.monotonic_time()
end
