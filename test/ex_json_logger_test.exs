defmodule ExJsonLoggerTest do
  use ExUnit.Case
  require Logger

  import TestUtils, only: [capture_log: 1]

  doctest ExJsonLogger

  setup_all do
    Logger.configure_backend(:console, [
      format: {ExJsonLogger, :format},
      device: :user,
      colors: [enabled: false]
    ])
  end

  describe "format/4" do
    test "log message is valid json" do
      Logger.configure_backend(:console, [metadata: [:user_id]])
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

  test "pids and refs are encoded" do
    Logger.configure_backend(:console, [metadata: [:pid, :ref]])
    ref = make_ref()
    pid = self()

    expected_ref = inspect(ref)
    expected_pid = inspect(pid)

    Logger.metadata(pid: pid, ref: ref)

    {_, message} = capture_log(fn ->
      Logger.info("this is a message")
    end)

    {:ok, decoded_log} = Poison.decode(message)
    assert %{
      "msg" => "this is a message",
      "level" => "info",
      "pid" => ^expected_pid,
      "ref" => ^expected_ref
    } = decoded_log
  end
end
