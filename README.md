# ExJsonLogger

[![Hex.pm](https://img.shields.io/hexpm/v/ex_json_logger.svg)](https://hex.pm/packages/ex_json_logger)

A drop-in replacement for `:console`'s formatter. ExJsonLogger takes standard `Logger` calls and JSON encodes them.
Ecto and Plug loggers are also included.

## Installation

[Available in Hex](https://hex.pm/packages/ex_json_logger), the package can be installed
by adding `ex_json_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_json_logger, "~> 0.1.3"}]
end
```

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
