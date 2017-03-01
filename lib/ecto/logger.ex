defmodule ExJsonLogger.Ecto.Logger do
  @moduledoc """
  An Ecto Logger replacement which captures and logs `Ecto.LogEntry` attributes through metadata.

  Logger Metadata available:
   * query - the query as string;
   * query_time - the time spent executing the query in milliseconds;
   * decode_time - the time spent decoding the result in milliseconds;
   * queue_time - the time spent to check the connection out in milliseconds;

  Metadata is filtered by default so keys will need to be whitelisted.

  ## Usage

  Add `ExJsonLogger.Ecto.Logger` to the Repo's configuration under the `:loggers` key.

      config :sample, Sample.Repo,
        adapter: Ecto.Adapters.MySQL,
        username: "root",
        password: "",
        database: "sample_dev",
        hostname: "localhost",
        pool_size: 10,
        loggers: [{ExJsonLogger.Ecto.Logger, :log, []}]
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

    times =
      [query_time, decode_time, queue_time] =
      [raw_query_time, raw_decode_time, raw_queue_time]
      |> Enum.map(&to_ms/1)

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
  defp to_ms(time) when is_integer(time) do
    time
    |> System.convert_time_unit(:native, :microsecond)
    |> Kernel./(1000) # divide to keep decimal precision
    |> Float.round(3)
  end
end
