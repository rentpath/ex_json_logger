defmodule ExJsonLogger do
  @moduledoc """
  A Logger formatter that converts logs to single line JSON.

  ## Logging additional information

  Use Logger's metadata to add additional data to the log output.
  This can be done through `Logger.metadata/1` or by passing Keywords to standard Logger calls in the optional second parameter.
  Logger filters metadata so any additional keys will need to be whitelisted in the backend's configuration.

  ## Usage

      config :logger, :console,
        format: {ExJsonLogger, :format},
        metadata: [
          :request_id,
          :additional_key
        ]

  *Currently tested with the `:console` logger backend.*

  """
  import Logger.Formatter, only: [format_date: 1, format_time: 1]

  @doc """
  Function referenced in the `:format` config.
  """
  @spec format(Logger.level(), Logger.message(),
               Logger.Formatter.time(), Keyword.t()) :: String.t()
  def format(level, msg, timestamp, metadata) do
    logger_info = %{
      level: level,
      time: format_timestamp(timestamp),
      msg: IO.iodata_to_binary(msg)
    }

    metadata
    |> Map.new(fn {k, v} -> {k, format_metadata(v)} end)
    |> Map.merge(logger_info)
    |> encode()
  rescue
    _ ->
      encode(%{
        level: :error,
        time: format_timestamp(timestamp),
        msg: "Could not format: #{inspect({level, msg, metadata})}"
      })
  end

  defp encode(log_event) do
    log_event
    |> Poison.encode!()
    |> Kernel.<>("\n")
  end

  defp format_timestamp({date, time}) do
    "#{format_date(date)} #{format_time(time)}"
  end

  defp format_metadata(pid) when is_pid(pid), do: inspect(pid)
  defp format_metadata(ref) when is_reference(ref), do: inspect(ref)
  defp format_metadata(other), do: other
end
