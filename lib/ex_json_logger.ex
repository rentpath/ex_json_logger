defmodule ExJsonLogger do
  @moduledoc """
  A Logger formatter that converts logs to single line JSON.

  ## Logging additional information

  Use Logger's metadata to add additional data to the log output.
  This can be done through `Logger.metadata/1` or by passing Keywords to standard Logger calls in the optional second parameter.
  Logger filter metadata so any additional keys will need to be whitelisted in the backend's configuration.

  ## Usage

  ```
  config :logger, :console,
    format: {ExJsonLogger, :format},
    metadata: [
      :request_id,
      :additional_key
    ]
  ```
  *Currently tested with the `:console` logger backend.*

  """
  alias Logger.{Utils}

  @doc """
  Function referenced in the `:format` config.
  """
  @spec format(Logger.level, Logger.message, Logger.time, Keyword.t) :: String.t
  def format(level, msg, timestamp, metadata) do
    %{
      level: level,
      time: format_time(timestamp),
      msg: (msg |> IO.iodata_to_binary)
    }
    |> Map.merge(Enum.into(metadata, %{}))
    |> Poison.encode!
    |> Kernel.<>("\n")
  end

  defp format_time({date, time}) do
    [Utils.format_date(date), Utils.format_time(time)]
    |> Enum.join(" ")
  end
end
