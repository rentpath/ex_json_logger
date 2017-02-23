defmodule TestUtils do
  import ExUnit.CaptureIO
  require Logger

  def capture_log(fun) do
    data = capture_io(:user, fn ->
      Process.put(:capture_log, fun.())
      Logger.flush()
    end)

    {Process.get(:capture_log), data}
  end
end

ExUnit.configure(exclude: [skip: true])
ExUnit.start()
