defmodule ExJsonLogger.Plug.Logger do
  @moduledoc """
  A plug for logging request information

  ## Usage

  To use with a Phoenix application, `replace Plug.Logger` in the projects endpoint.ex file with `ExJsonLogger.Plug.Logger`:

  ```
  # plug Plug.Logger
  plug ExJsonLogger.Plug.Logger
  ```

  ## Options
  * `:log` - The log level at which this plug should log its request info.
  Default is `:info`.
  """

  require Logger
  alias Plug.Conn
  @behaviour Plug

  @spec init(Keyword.t) :: Logger.level
  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  @spec call(Conn.t, Logger.level) :: Conn.t
  def call(conn, level) do
    start_time = current_time()

    Conn.register_before_send(conn, fn conn ->
      stop_time = current_time()
      diff = stop_time - start_time
      duration = System.convert_time_unit(diff, :native, :micro_seconds)

      stats = []
      |> Keyword.put(:method, conn.method)
      |> Keyword.put(:path, conn.request_path)
      |> Keyword.merge(formatted_phoenix_info(conn))
      |> Keyword.put(:status, conn.status)
      |> Keyword.put(:duration, format_time(duration))

      Logger.log(level, fn -> {"", stats} end)

      conn
    end)
  end

  defp formatted_phoenix_info(%{private: %{
                                  phoenix_format: format,
                                  phoenix_controller: controller,
                                  phoenix_action: action
                                }}) do
    [
      {:format, format},
      {:controller, controller |> inspect},
      {:action, action |> Atom.to_string}
    ]
  end
  defp formatted_phoenix_info(_), do: []

  defp format_time(time), do: (time / 1000)

  defp current_time, do: System.monotonic_time()
end
