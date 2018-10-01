defmodule TestUtils do
  import ExUnit.CaptureIO
  require Logger

  @spec capture_log(fun()) :: String.t()
  def capture_log(fun) do
    capture_io(:user, fn ->
      Process.put(:capture_log, fun.())
      Logger.flush()
    end)
  end
end

ExUnit.configure(exclude: [skip: true])
ExUnit.start()
