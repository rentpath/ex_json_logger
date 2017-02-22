defmodule ExJsonLogger.Plug.LoggerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import ExUnit.CaptureIO
  require Logger

  @default_metadata [
    :method,
    :path,
    :status,
    :duration
  ]

  @phoenix_metadata [
    :format,
    :controller,
    :action
  ]

  defmodule MyApp do
    use Plug.Builder

    plug ExJsonLogger.Plug.Logger
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Poison
    plug :passthrough

    defp passthrough(conn, _) do
      Plug.Conn.send_resp(conn, 200, "Passthrough")
    end
  end

  defp put_phoenix_privates(conn) do
    conn
    |> put_private(:phoenix_controller, __MODULE__)
    |> put_private(:phoenix_action, :show)
    |> put_private(:phoenix_format, "json")
  end

  defp capture_log(fun) do
    data = capture_io(:user, fn ->
      Process.put(:capture_log, fun.())
      Logger.flush()
    end)

    {Process.get(:capture_log), data}
  end

  describe "when request is made to phoenix controller" do
    test "request information is added to metadata" do
      Logger.configure_backend(:console, [
        format: "$metadata",
        device: :user,
        metadata: (@default_metadata ++ @phoenix_metadata),
        colors: [enabled: false]
      ])

      {_conn, message} = capture_log fn ->
        conn(:get, "/") |> put_phoenix_privates |> MyApp.call([])
      end

      assert message =~ "method=GET"
      assert message =~ "path=/"
      assert message =~ "status=200"
      assert message =~ ~r/duration=\d+.\d/u
      assert message =~ "format=json"
      assert message =~ "controller=#{ inspect(__MODULE__) }"
      assert message =~ "action=show"
    end
  end

  describe "when request is made to non phoenix controller" do
    test "request information is added to metadata" do
      Logger.configure_backend(:console, [
        format: "$metadata",
        device: :user,
        metadata: @default_metadata,
        colors: [enabled: false]
      ])

      {_conn, message} = capture_log fn ->
        conn(:get, "/") |> MyApp.call([])
      end

      assert message =~ "method=GET"
      assert message =~ "path=/"
      assert message =~ "status=200"
      assert message =~ ~r/duration=\d+.\d/u
      refute message =~ "format="
      refute message =~ "controller="
      refute message =~ "action="
    end
  end

  describe "when metadata isn't included in configuration" do
    test "metadata is filtered" do
      Logger.configure_backend(:console, [
        format: "$metadata",
        device: :user,
        metadata: [],
        colors: [enabled: false]
      ])

      {_conn, message} = capture_log fn ->
        conn(:get, "/") |> MyApp.call([])
      end

      assert message == ""
    end
  end
end
