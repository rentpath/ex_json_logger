# ExJsonLogger

[![Hex.pm](https://img.shields.io/hexpm/v/ex_json_logger.svg)](https://hex.pm/packages/ex_json_logger)

A drop-in replacement for `:console`'s formatter. ExJsonLogger takes standard `Logger` calls and JSON encodes them.
Ecto and Plug loggers are also included.

## Installation

[Available in Hex](https://hex.pm/packages/ex_json_logger), the package can be installed
by adding `ex_json_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_json_logger, "~> 1.1.0"}]
end
```

```elixir
config :logger, :console,
  format: {ExJsonLogger, :format},
  metadata: [
    :action,
    :controller,
    :duration,
    :format,
    :method,
    :path,
    :request_id,
    :status
  ]
```

Sensitive keys in the logger output will be recursively discovered and redacted. The keys redacted
and the replacement string used can be configured as follows:

```
config :ex_json_logger,
   filtered_replacement: "[XXXXXXX]",
   filtered_keys: ["password", "secrets"],
   drop_lines_matching: nil || ~r(V1\.HealthCheckController) || "V1.HealthCheckController" || ["HealthCheck", "PrivateController"]
```

Sensible defaults are in place for keys to redact.

drop_lines_matching uses `String.contains?()` when not nil

For additional configuration and metadata option refer to `moduledocs`

## Documentation

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc) and available online at [https://hexdocs.pm/ex_json_logger](https://hexdocs.pm/ex_json_logger)

 * Logger - *For more documentation reference `ExJsonLogger`*
 * Plug - *For more documentation reference `ExJsonLogger.Plug.Logger`*
 * Ecto - *For more documentation reference `ExJsonLogger.Ecto.Logger`*


## Running the tests
Tests include
- Linter via [Credo](https://hex.pm/packages/credo)
- Coverage via [Excoveralls](https://hex.pm/packages/excoveralls)
- run tests: `script/test`
- run tests with coverage: `script/test --coverage`

## Contributing
-  If you modify code, add a corresponding test and documentation(if applicable).
-  Create a Pull Request (please squash to one concise commit).
-  Thanks!

## License
[MIT](https://github.com/rentpath/ex_json_logger/blob/master/LICENSE)
