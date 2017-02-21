defmodule ExJsonLogger.Ecto.LoggerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  require Logger

  describe "log/1" do
    test "" do
      assert 1 + 1 == 2
    end
  end

  describe "log/2" do
    
  end
end
