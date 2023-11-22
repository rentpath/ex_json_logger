Benchee.run(
  %{"format/4" => fn {level, msg, timestamp, metadata} -> ExJsonLogger.format(level, msg, timestamp, metadata) end},
  inputs: %{
    "debug" =>
      {_level = :debug, _msg = "this is a message", _ts = {{2023, 11, 22}, {16, 19, 5, 729}}, _meta = [user_id: 11]},
    "info" =>
      {_level = :info, _msg = "this is a message", _ts = {{2023, 11, 22}, {16, 19, 5, 737}},
       _meta = [pid: self(), ref: :erlang.make_ref()]}
  }
)
