defmodule ExJsonLoggerTest do
  use ExUnit.Case

  import TestUtils, only: [capture_log: 1]

  require Logger

  doctest ExJsonLogger

  setup_all do
    Logger.configure_backend(
      :console,
      format: {ExJsonLogger, :format},
      device: :user,
      colors: [enabled: false]
    )
  end

  describe "resursive_drop/2" do
    test "removes top level key" do
      result =
        ExJsonLogger.recursive_filter(
          %{key1: 1, key2: 2},
          [:key1]
        )

      assert result == %{key2: 2, key1: "[REDACTED]"}
    end

    test "removes nested level key" do
      result =
        ExJsonLogger.recursive_filter(
          %{key1: 1, session: %{sekret: 42}},
          [:sekret]
        )

      assert result == %{key1: 1, session: %{sekret: "[REDACTED]"}}
    end
  end

  describe "format/4" do
    test "log message is valid json" do
      Logger.configure_backend(:console, metadata: [:user_id])
      Logger.metadata(user_id: 11)

      message =
        capture_log(fn ->
          Logger.debug("this is a message")
        end)

      {:ok, decoded_log} = Jason.decode(message)
      log_without_time = Map.drop(decoded_log, ["time"])

      assert %{
               "msg" => "this is a message",
               "level" => "debug",
               "user_id" => 11
             } == log_without_time
    end

    test "sanitizes certain params" do
      Logger.configure_backend(:console, metadata: [:user_id, :session])
      Logger.metadata(user_id: 11, session: %{password: "sekret", flag: "yes"})

      message =
        capture_log(fn ->
          Logger.debug("this is a message")
        end)

      {:ok, decoded_log} = Jason.decode(message)
      log_without_time = Map.drop(decoded_log, ["time"])

      expected = %{
        "msg" => "this is a message",
        "level" => "debug",
        "user_id" => 11,
        "session" => %{"flag" => "yes", "password" => "[REDACTED]"}
      }

      assert log_without_time == expected
    end

    test "drops matching log lines" do
      Logger.configure_backend(:console, metadata: [:user_id, :controller])
      Application.put_env(:ex_json_logger, :drop_lines_matching, "Healthcheck")
      Logger.metadata(user_id: 11, controller: "Healthcheck")

      message =
        capture_log(fn ->
          Logger.debug("this is a message")
        end)

      assert message == ""
    end
  end

  test "pids and refs are encoded" do
    Logger.configure_backend(:console, metadata: [:pid, :ref])
    ref = make_ref()
    pid = self()

    expected_ref = inspect(ref)
    expected_pid = inspect(pid)

    Logger.metadata(pid: pid, ref: ref)

    message =
      capture_log(fn ->
        Logger.info("this is a message")
      end)

    {:ok, decoded_log} = Jason.decode(message)

    assert %{
             "msg" => "this is a message",
             "level" => "info",
             "pid" => ^expected_pid,
             "ref" => ^expected_ref
           } = decoded_log
  end
end
