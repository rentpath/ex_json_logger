defmodule ExJsonLogger.Ecto.LoggerTest do
  use ExUnit.Case
  require Logger
  import TestUtils, only: [capture_log: 1]

  @default_metadata [
    :decode_time,
    :db_duration,
    :query,
    :query_time,
    :queue_time,
    :query_params
  ]

  describe "log/2" do
    test "entry values are formatted and put into metadata" do
      Logger.configure_backend(:console, [
        format: "$metadata",
        device: :user,
        metadata: @default_metadata,
        colors: [enabled: false]
      ])

      entry = %{
        query_time: 3_638_533,
        decode_time:   79_113,
        queue_time:   123_169,
        query: "INSERT INTO `x` (`id`, `label`, `updated_at`) VALUES (?,?,?)",
        params: [1, "20170504-373-cb4150f", {{2017, 5, 10}, {21, 34, 53, 998254}}, {{2017, 5, 10}, {21, 34, 53, 998264}}]
      }

      {_, message} = capture_log(fn ->
        ExJsonLogger.Ecto.Logger.log(entry)
      end)

      assert message =~ "decode_time=0.079 "
      assert message =~ "db_duration=3.84 "
      assert message =~ "query_time=3.638 "
      assert message =~ "queue_time=0.123 "
      assert message =~ "query=INSERT INTO `x` (`id`, `label`, `updated_at`) VALUES (?,?,?)"
      assert message =~ "query_params=[1, \"20170504-373-cb4150f\", {{2017, 5, 10}, {21, 34, 53, 998254}}, {{2017, 5, 10}, {21, 34, 53, 998264}}]"
    end
  end
end
