defmodule ExJsonLogger do
  @moduledoc """
  """
  alias Logger.{Utils}

  @doc """
  log formatter replacement. Injected through the :format key

  config :logger, :console,
    format: {ExJsonLogger, :format}
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
