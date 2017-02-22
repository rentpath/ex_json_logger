defmodule ExJsonLogger.Ecto.Logger do
  @moduledoc """
  """

  require Logger

  #TODO: Do I need a log/1 for `compile_time_purge_level`?

  @spec log(Ecto.LogEntry.t, Logger.level) :: Ecto.LogEntry.t
  def log(entry, level \\ :debug) do
    %{
      query_time:  raw_query_time,
      decode_time: raw_decode_time,
      queue_time:  raw_queue_time,
      query:       query
    } = entry

    times =
      [query_time, decode_time, queue_time] =
      [raw_query_time, raw_decode_time, raw_queue_time]
      |> Enum.map(&to_ms/1)

    # TODO: do we care about adding here.
    # If we wanted this info we could add up the values else where
    duration = times
    |> Enum.sum
    |> Float.round(3)

    metadata = []
    |> Keyword.put(:db_duration, duration)
    |> Keyword.put(:decode_time, decode_time)
    |> Keyword.put(:query_time, query_time)
    |> Keyword.put(:queue_time, queue_time)
    |> Keyword.put(:query, query)

    Logger.log(level, fn -> {"", metadata} end)

    entry
  end

  defp to_ms(nil), do: 0.0
  defp to_ms(time) do
    time
    |> System.convert_time_unit(:native, :micro_seconds)
    |> Kernel./(1000) # divide to keep decimal precision
    |> Float.round(3)
  end
end
