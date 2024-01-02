# ExJsonLogger

[![Module Version](https://img.shields.io/hexpm/v/ex_json_logger.svg)](https://hex.pm/packages/ex_json_logger)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ex_json_logger/)
[![Total Download](https://img.shields.io/hexpm/dt/ex_json_logger.svg)](https://hex.pm/packages/ex_json_logger)
[![License](https://img.shields.io/hexpm/l/ex_json_logger.svg)](https://github.com/rentpath/ex_json_logger/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/rentpath/ex_json_logger.svg)](https://github.com/rentpath/ex_json_logger/commits/master)

A drop-in replacement for `:console`'s formatter. ExJsonLogger takes standard `Logger` calls and JSON encodes them.

Ecto and Plug loggers are also included.

## Installation

The package can be installed by adding `:ex_json_logger` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_json_logger, "~> 1.4.0"}
  ]
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

For additional configuration and metadata option refer to `moduledocs`

## Documentation

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc) and available online at [https://hexdocs.pm/ex_json_logger](https://hexdocs.pm/ex_json_logger)

 * Logger - *For more documentation reference `ExJsonLogger`*
 * Plug - *For more documentation reference `ExJsonLogger.Plug.Logger`*
 * Ecto - *For more documentation reference `ExJsonLogger.Ecto.Logger`*


## Running the tests

Tests include:

- Linter via [Credo](https://hex.pm/packages/credo)
- Coverage via [Excoveralls](https://hex.pm/packages/excoveralls)
- run tests: `script/test`
- run tests with coverage: `script/test --coverage`

## Running the benchmarks

A basic benchee benchmarking script is available for testing performance
improvements:

```bash
mix run bench/format.exs
```

## Contributing

-  If you modify code, add a corresponding test and documentation(if applicable).
-  Create a Pull Request (please squash to one concise commit).
-  Thanks!

## Copyright and License

Copyright (c) 2017 RentPath

This library licensed under the [MIT license](./LICENSE.md).
