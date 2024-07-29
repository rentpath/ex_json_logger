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

  @pid_str "#PID"

  defmodule LogEvent do
    @moduledoc false
    defstruct fields: []
    @type t :: %__MODULE__{fields: [{atom, term}]}

    defimpl Jason.Encoder do
      @spec encode(ExJsonLogger.LogEvent.t(), Jason.Encode.opts()) :: iodata
      def encode(%{fields: fields}, opts) do
        Jason.Encode.keyword(fields, opts)
      end
    end
  end

  @doc """
  Function referenced in the `:format` config.
  """
  @spec format(Logger.level(), Logger.message(), Logger.Formatter.time(), Keyword.t()) :: iodata()
  def format(level, msg, timestamp, metadata) do
    [
      {"level", level},
      {"time", format_timestamp(timestamp)},
      {"msg", IO.iodata_to_binary(msg)}
      | metadata(metadata)
    ]
    |> encode()
  rescue
    _ ->
      encode([
        {"level", "error"},
        {"time", format_timestamp(timestamp)},
        {"msg", "ExJsonLogger could not format: #{inspect({level, msg, metadata})}"}
      ])
  end

  defp encode(fields) do
    [Jason.encode_to_iodata!(%LogEvent{fields: fields}), ?\n]
  end

  defp metadata([] = empty), do: empty

  defp metadata([kv | rest]) do
    if kv = format_metadata(kv) do
      [kv | metadata(rest)]
    else
      metadata(rest)
    end
  end

  defp format_timestamp({date, time}) do
    unsafe_fragment([format_date(date), ?\s, format_time(time)])
  end

  defp format_metadata(pid) when is_pid(pid) do
    unsafe_fragment([@pid_str | :erlang.pid_to_list(pid)])
  end

  defp format_metadata(ref) when is_reference(ref) do
    unsafe_fragment(:erlang.ref_to_list(ref))
  end

  defp format_metadata(other), do: other

  defp unsafe_fragment(data) do
    Jason.Fragment.new([?", data, ?"])
  end
end
