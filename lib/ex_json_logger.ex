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
    encode([
      {"level", level},
      {"time", format_timestamp(timestamp)},
      {"msg", IO.iodata_to_binary(msg)}
      | metadata(metadata)
    ])
  rescue
    _e ->
      encode([
        {"level", "error"},
        {"time", format_timestamp(timestamp)},
        {"msg", "ExJsonLogger could not format: #{inspect({level, msg, metadata})}"}
      ])
  end

  @compile inline: [encode: 1]
  defp encode(fields) do
    [Jason.encode_to_iodata!(%LogEvent{fields: fields}), ?\n]
  end

  defp metadata([kv | rest]) do
    if kv = format_metadata(kv) do
      [kv | metadata(rest)]
    else
      metadata(rest)
    end
  end

  defp metadata([] = empty), do: empty

  defmacrop unsafe_fragment(data) do
    quote do
      Jason.Fragment.new([?", unquote_splicing(data), ?"])
    end
  end

  defp format_timestamp({date, time}) do
    unsafe_fragment([format_date(date), ?\s, format_time(time)])
  end

  defp format_metadata({drop, _}) when drop in [:msg, :time, :level, :report_cb, :gl], do: nil

  defp format_metadata({_, nil} = kv), do: kv
  defp format_metadata({_, string} = kv) when is_binary(string), do: kv
  defp format_metadata({_, number} = kv) when is_number(number), do: kv

  defp format_metadata({key, pid}) when is_pid(pid) do
    {key, unsafe_fragment(["#PID", :erlang.pid_to_list(pid)])}
  end

  defp format_metadata({key, ref}) when is_reference(ref) do
    {key, unsafe_fragment([:erlang.ref_to_list(ref)])}
  end

  defp format_metadata({key, port}) when is_port(port) do
    {key, unsafe_fragment([:erlang.port_to_list(port)])}
  end

  defp format_metadata({key, atom}) when is_atom(atom) do
    value =
      case Atom.to_string(atom) do
        "Elixir." <> rest -> rest
        other -> other
      end

    {key, value}
  end

  defp format_metadata({mfa_key, {mod, fun, arity}})
       when mfa_key in [:mfa, :initial_call] and is_atom(mod) and is_atom(fun) and is_integer(arity) do
    {mfa_key, Exception.format_mfa(mod, fun, arity)}
  end

  defp format_metadata({list_key, list}) when list_key in [:file, :function] and is_list(list) do
    {list_key, List.to_string(list)}
  end

  defp format_metadata({k, %_struct{} = v} = kv) do
    cond do
      impl = String.Chars.impl_for(v) -> {k, impl.to_string(v)}
      Jason.Encoder.impl_for(v) != Jason.Encoder.Any -> kv
      true -> {k, inspect(v)}
    end
  end

  defp format_metadata(other), do: other
end
