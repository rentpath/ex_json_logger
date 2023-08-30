defmodule ExJsonLogger.Plug.LoggerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import TestUtils, only: [capture_log: 1]

  require Logger

  @default_metadata [
    :method,
    :path,
    :status,
    :duration,
    :query_string
  ]

  @phoenix_metadata [
    :format,
    :controller,
    :action
  ]

  defmodule MyApp do
    use Plug.Builder

    plug(ExJsonLogger.Plug.Logger)

    plug(
      Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Jason
    )

    plug(:passthrough)

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

  describe "when request is made to phoenix controller" do
    test "request information is added to metadata" do
      Logger.configure_backend(
        :console,
        format: "$metadata",
        device: :user,
        metadata: @default_metadata ++ @phoenix_metadata,
        colors: [enabled: false]
      )

      message =
        capture_log(fn ->
          :get
          |> conn("/?one=value&and=another")
          |> put_phoenix_privates
          |> MyApp.call([])
        end)

      assert message =~ "method=GET"
      assert message =~ "path=/"
      assert message =~ "status=200"
      assert message =~ ~r/duration=\d+.\d/u
      assert message =~ "query_string=one=value&and=another"
      assert message =~ "format=json"
      assert message =~ "controller=#{inspect(__MODULE__)}"
      assert message =~ "action=show"
    end
  end

  describe "when request is made to non phoenix controller" do
    test "request information is added to metadata" do
      Logger.configure_backend(
        :console,
        format: "$metadata",
        device: :user,
        metadata: @default_metadata,
        colors: [enabled: false]
      )

      message =
        capture_log(fn ->
          :get
          |> conn("/?one=value&and=another")
          |> MyApp.call([])
        end)

      assert message =~ "method=GET"
      assert message =~ "path=/"
      assert message =~ "status=200"
      assert message =~ ~r/duration=\d+.\d/u
      assert message =~ "query_string=one=value&and=another"
      refute message =~ "format="
      refute message =~ "controller="
      refute message =~ "action="
    end
  end

  describe "when metadata isn't included in configuration" do
    test "metadata is filtered" do
      Logger.configure_backend(
        :console,
        format: "$metadata",
        device: :user,
        metadata: [],
        colors: [enabled: false]
      )

      message =
        capture_log(fn ->
          :get
          |> conn("/")
          |> MyApp.call([])
        end)

      assert message == ""
    end
  end
end
