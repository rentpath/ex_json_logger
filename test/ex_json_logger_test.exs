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
  end

  test "pids and refs are encoded" do
    Logger.configure_backend(:console, metadata: [:pid, :ref])
    ref = make_ref()
    pid = self()

    <<"#Reference", ref_code::binary>> = inspect(ref)
    expected_ref = "#Ref" <> ref_code
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

  test "invalid byte" do
    Logger.configure_backend(:console, metadata: [])
    message = capture_log(fn -> Logger.debug(<<219, 229>>) end)
    assert %{"level" => "error", "msg" => "��"} = Jason.decode!(message)
  end
end
