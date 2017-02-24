defmodule ExJsonLoggerTest do
  use ExUnit.Case
  require Logger

  import TestUtils, only: [capture_log: 1]

  doctest ExJsonLogger

  describe "format/4" do
    test "log message is valid json" do
      Logger.configure_backend(:console, [
        format: {ExJsonLogger, :format},
        device: :user,
        metadata: [:user_id],
        colors: [enabled: false]
      ])

      Logger.metadata(user_id: 11)

      {_, message} = capture_log(fn ->
        Logger.debug("this is a message")
      end)

      {:ok, decoded_log} = Poison.decode(message)
      assert %{
        "msg" => "this is a message",
        "level" => "debug",
        "user_id" => 11
      } = decoded_log
    end
  end
end
