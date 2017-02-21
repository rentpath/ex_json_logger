defmodule ExJsonLogger.Plug.LoggerTest do
  use ExUnit.Case
  use Plug.Test

  import ExUnit.CaptureIO
  require Logger

  test "" do
    assert 1 + 1 == 2
  end
end
