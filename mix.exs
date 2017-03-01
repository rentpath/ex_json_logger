defmodule ExJsonLogger.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_json_logger,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package(),
      aliases: aliases(),
      deps: deps(),
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
      docs: [
       # main: "MyApp", # The main page in the docs
       # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]

  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: [:dev], runtime: false},
      {:ecto, "~> 2.1", only: [:dev], optional: true},
      {:excoveralls, "~> 0.6.1", only: [:test]},
      {:credo, "~> 0.6.0", only: [:dev, :test]},
      {:dialyxir, "~>0.5", only: [:dev], runtime: false},
      {:plug, "~> 1.0"},
      {:poison, ">= 1.4.0"}
    ]
  end

  defp package do
    [
      name: :ex_json_logger,
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["devadmin@rentpath.com", "Eric Toulson <ebtoulson@gmail.com>"],
      links: %{"GitHub" => "https://github.com/rentpath/ex_json_logger"},
      licenses: ["The MIT License"]
    ]
  end

  defp aliases do
    [dialyzer: "dialyzer --halt-exit-status"]
  end
end
