defmodule ExJsonLogger.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_json_logger,
      version: "0.1.2",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package(),
      aliases: aliases(),
      deps: deps(),
      description: description(),
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test
      ],
      dialyzer: [
        plt_add_deps: :transitive,
        ignore_warnings: ".dialyzerignore"
      ],

      # Docs
      name: "ex_json_logger",
      source_url: "https://github.com/rentpath/ex_json_logger",
      docs: docs()
    ]

  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: [:dev], runtime: false},
      {:ecto, "~> 2.1", only: [:dev], optional: true},
      {:excoveralls, "~> 0.6", only: [:test]},
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:dialyxir, "~>0.5", only: [:dev], runtime: false},
      {:plug, "~> 1.0"},
      {:poison, ">= 1.4.0"}
    ]
  end

  defp description do
    """
    JSON formatter for Loggers console backend, Plug and Ecto formatters included.
    """
  end

  defp package do
    [
      name: :ex_json_logger,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["devadmin@rentpath.com", "Eric Toulson <ebtoulson@gmail.com>"],
      links: %{"GitHub" => "https://github.com/rentpath/ex_json_logger"},
      licenses: ["The MIT License"]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ]
    ]
  end

  defp aliases do
    [dialyzer: "dialyzer --halt-exit-status"]
  end
end
