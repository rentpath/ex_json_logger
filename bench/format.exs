Benchee.run(
  %{"format/4" => fn {level, msg, timestamp, metadata} -> ExJsonLogger.format(level, msg, timestamp, metadata) end},
  inputs: %{
    "debug" =>
      {_level = :debug, _msg = "this is a message", _ts = {{2023, 11, 22}, {16, 19, 5, 729}}, _meta = [user_id: 11]},
    "info" =>
      {_level = :info, _msg = "this is a message", _ts = {{2023, 11, 22}, {16, 19, 5, 737}},
       _meta = [pid: self(), ref: :erlang.make_ref()]},
    "metadata: :all" =>
      {_level = :debug, _msg = "this is a message", _ts = {{2023, 11, 22}, {16, 19, 5, 737}},
       _meta = [
         line: 95,
         pid: self(),
         time: 1_703_215_516_705_225,
         file: ~c"/Users/x/Developer/ex_json_logger/test/ex_json_logger_test.exs",
         gl: self(),
         domain: [:elixir],
         mfa: {ExJsonLoggerTest, :"test format/4 structured", 1},
         report_cb: &:logger.format_otp_report/1
       ]}
  }
)
