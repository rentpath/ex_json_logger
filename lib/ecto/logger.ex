defmodule ExJsonLogger.Ecto.Logger do
  @moduledoc """
  """

  require Logger

  @spec log(Ecto.LogEntry.t, Logger.level) :: Ecto.LogEntry.t
  def log(entry, level \\ :debug) do
    %{
      query_time:  raw_query_time,
      decode_time: raw_decode_time,
      queue_time:  raw_queue_time,
      query:       query
    } = entry

    [query_time, decode_time, queue_time] =
      [raw_query_time, raw_decode_time, raw_queue_time]
      |> Enum.map(&format_time/1)

    metadata = []
    |> Keyword.put(:decode_time, decode_time)
    |> Keyword.put(:db_duration, (query_time + decode_time + queue_time))
    |> Keyword.put(:query, query)
    |> Keyword.put(:query_time, query_time)
    |> Keyword.put(:queue_time, queue_time)

    Logger.log(level, fn -> {"", metadata} end)

    entry
  end

  defp format_time(nil), do: 0.0
  defp format_time(time) do
    # divide to keep decimal precision
    System.convert_time_unit(time, :native, :micro_seconds) / 1000
  end
end
