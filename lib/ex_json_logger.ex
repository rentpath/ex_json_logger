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

  @filtered_keys ["password", "token", "authorization", "api_token", "_csrf_token"]

  @doc """
  Function referenced in the `:format` config.
  """
  @spec format(Logger.level(), Logger.message(), Logger.Formatter.time(), Keyword.t()) ::
          String.t()
  def format(level, msg, timestamp, metadata) do
    logger_info = %{
      level: level,
      time: format_timestamp(timestamp),
      msg: IO.iodata_to_binary(msg)
    }

    metadata
    |> Map.new(fn {k, v} -> {k, format_metadata(v)} end)
    |> Map.merge(logger_info)
    |> recursive_filter()
    |> encode()
    |> drop_if_matching()
  rescue
    _ ->
      encode(%{
        level: :error,
        time: format_timestamp(timestamp),
        msg: "Could not format: #{inspect({level, msg, metadata})}"
      })
  end

  defp exclusion_pattern do
    Application.get_env(:ex_json_logger, :drop_lines_matching, nil)
  end

  defp drop_if_matching(str, exclusion_pattern \\ exclusion_pattern())

  defp drop_if_matching(str, nil), do: str

  defp drop_if_matching(str, exclusion_pattern) do
    if String.contains?(str, exclusion_pattern) do
      ""
    else
      str
    end
  end

  defp encode(log_event) do
    log_event
    |> Jason.encode()
    |> case do
      {:ok, result} ->
        result

      _ ->
        Jason.encode!(%{encode_error: inspect(log_event)})
    end
    |> Kernel.<>("\n")
  end

  def filtered_keys do
    Application.get_env(:ex_json_logger, :filtered_keys) || @filtered_keys
  end

  def filtered_replacement do
    Application.get_env(:ex_json_logger, :filtered_replacement) || "[REDACTED]"
  end

  @spec recursive_filter(any(), [atom()], String.t()) :: any()
  def recursive_filter(data, keys \\ filtered_keys(), replacement \\ filtered_replacement())

  def recursive_filter(%{__struct__: mod} = struct, keys, replacement) when is_atom(mod) do
    struct
    |> Map.from_struct()
    |> recursive_filter(keys, replacement)
  end

  def recursive_filter(data, keys, replacement) when is_map(data) do
    ks = Enum.map(keys, &to_string/1)

    Enum.reduce(data, %{}, fn {k, v}, acc ->
      v2 = maybe_recursive_filter(v, keys, replacement)

      if Enum.member?(ks, to_string(k)) do
        Map.put(acc, k, replacement)
      else
        Map.put(acc, k, v2)
      end
    end)
  end

  defp maybe_recursive_filter(v, keys, replacement) do
    case v do
      v when is_map(v) -> recursive_filter(v, keys, replacement)
      v -> v
    end
  end

  defp format_timestamp({date, time}) do
    "#{format_date(date)} #{format_time(time)}"
  end

  defp format_metadata(pid) when is_pid(pid), do: inspect(pid)
  defp format_metadata(ref) when is_reference(ref), do: inspect(ref)

  defp format_metadata(other), do: other
end
