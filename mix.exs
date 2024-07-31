defmodule ExJsonLogger.Mixfile do
  use Mix.Project

  @source_url "https://github.com/rentpath/ex_json_logger"
  @version "1.4.0"

  def project do
    [
      app: :ex_json_logger,
      name: "ex_json_logger",
      version: @version,
      elixir: ">= 1.14.0",
      elixirc_options: [warnings_as_errors: true],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto, "~> 3.11", only: [:dev], optional: true},
      {:excoveralls, "~> 0.11", only: [:test]},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:plug, "~> 1.14"},
      {:jason, "~> 1.0"},
      {:benchee, "~> 1.2", only: :dev}
    ]
  end

  defp package do
    [
      name: :ex_json_logger,
      description: "JSON formatter for Loggers console backend, Plug, and Ecto formatters included.",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["devadmin@rentpath.com", "Eric Toulson <ebtoulson@gmail.com>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
