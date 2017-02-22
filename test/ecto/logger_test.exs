defmodule ExJsonLogger.Ecto.LoggerTest do
  use ExUnit.Case
  require Logger
  import TestUtils, only: [capture_log: 1]

  @default_metadata [
    :decode_time,
    :db_duration,
    :query,
    :query_time,
    :queue_time
  ]

  describe "log/1" do
    test "" do
      assert 1 + 1 == 2
    end
  end

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
        query: "SELECT n0.`id`, n0.`title`, n0.`text`, n0.`created_at`, n0.`inserted_at`, n0.`updated_at` FROM `notes` AS n0"
      }

      {_, message} = capture_log(fn ->
        ExJsonLogger.Ecto.Logger.log(entry)
      end)

      assert message =~ "decode_time=0.079 "
      assert message =~ "db_duration=3.84 "
      assert message =~ "query_time=3.638 "
      assert message =~ "queue_time=0.123 "
      # TODO: is this valid?
      assert message =~ "query=SELECT n0.`id`, n0.`title`, n0.`text`, n0.`created_at`, n0.`inserted_at`, n0.`updated_at` FROM `notes` AS n0"
    end
  end
end
