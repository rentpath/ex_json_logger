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

  describe "format/4" do
    test "log message is valid json" do
      Logger.configure_backend(:console, metadata: [:user_id])
      Logger.metadata(user_id: 11)

      message =
        capture_log(fn ->
          Logger.debug("this is a message")
        end)

      {:ok, decoded_log} = Jason.decode(message)

      assert %{
               "msg" => "this is a message",
               "level" => "debug",
               "user_id" => 11
             } = decoded_log
    end

    test "pids and refs are encoded" do
      Logger.configure_backend(:console, metadata: [:pid, :ref])
      ref = make_ref()
      pid = self()
      Logger.metadata(pid: pid, ref: ref)

      "#Reference" <> encoded_ref = inspect(ref)
      expected_ref = "#Ref" <> encoded_ref
      expected_pid = inspect(pid)

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

    test "metadata: :all" do
      Logger.configure_backend(:console, metadata: :all)

      message =
        capture_log(fn ->
          Logger.debug("this is a message")
        end)

      assert %{
               "domain" => ["elixir"],
               "file" => file,
               "level" => "debug",
               "line" => line,
               "mfa" => "ExJsonLoggerTest.\"test format/4 metadata: :all\"/1",
               "msg" => "this is a message",
               "pid" => "#PID<0." <> _self_pid,
               "time" => _time
             } = Jason.decode!(message)

      assert String.ends_with?(file, "/ex_json_logger/test/ex_json_logger_test.exs")
      assert is_integer(line)
    end

    test "structured" do
      Logger.configure_backend(:console, metadata: :all)

      message =
        capture_log(fn ->
          Logger.debug(msg: "this is a message", where: "somewhere", ok: :ok)
        end)

      assert %{
               "domain" => ["elixir"],
               "file" => file,
               "level" => "debug",
               "line" => line,
               "mfa" => "ExJsonLoggerTest.\"test format/4 structured\"/1",
               "msg" => "[msg: \"this is a message\", where: \"somewhere\", ok: :ok]",
               "pid" => "#PID<0." <> _self_pid,
               "time" => _time
             } = Jason.decode!(message)

      assert String.ends_with?(file, "/ex_json_logger/test/ex_json_logger_test.exs")
      assert is_integer(line)
    end

    test "metadata cannot override :msg and :level" do
      Logger.configure_backend(:console, metadata: :all)

      message =
        capture_log(fn ->
          Logger.debug("this is a message", level: :error, msg: "this is metadata")
        end)

      assert %{"level" => "debug", "msg" => "this is a message"} = Jason.decode!(message)
    end

    test "metadata can override :time" do
      Logger.configure_backend(:console, metadata: :all)

      message =
        capture_log(fn ->
          Logger.debug("this is a message", time: 0)
        end)

      assert %{"time" => "1970" <> _} = Jason.decode!(message)
    end
  end

  describe "protocols" do
    test "String.Chars" do
      Logger.configure_backend(:console, metadata: :all)

      message =
        capture_log(fn ->
          Logger.debug("this is a message", some_key: %StringCharsValue{message: "hello"})
        end)

      assert %{"some_key" => "StringCharsValue says: hello"} = Jason.decode!(message)
    end

    test "Jason.Encoder" do
      Logger.configure_backend(:console, metadata: :all)

      message =
        capture_log(fn ->
          Logger.debug("this is a message", some_key: %JasonEncoderValue{message: "hello", secret: "password"})
        end)

      assert %{"some_key" => %{"message" => "hello"}} = Jason.decode!(message)
    end

    test "Inspect" do
      Logger.configure_backend(:console, metadata: :all)

      message =
        capture_log(fn ->
          Logger.debug("this is a message", some_key: %InspectValue{message: "hello", secret: "password"})
        end)

      assert %{"some_key" => "#InspectValue<message: \"hello\", ...>"} = Jason.decode!(message)
    end
  end
end
