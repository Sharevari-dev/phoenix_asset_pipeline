defmodule PhoenixAssetPipeline.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description """
  Asset pipeline for Phoenix app
  """

  def project do
    [
      app: :phoenix_asset_pipeline,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: @description,
      package: package(),
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      source_url: "https://github.com/Youimmi/phoenix_asset_pipeline"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {PhoenixAssetPipeline, []},
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ["lib", "LICENSE", "mix.exs", "README.md"],
      maintainers: [],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Youimmi/phoenix_asset_pipeline"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:brotli, "~> 0.2"},
      {:coffee_compiler, "~> 0.1"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:file_system, "~> 0.2"},
      {:phoenix, "~> 1.5.0"},
      {:phoenix_html, "~> 2.14"},
      {:plug_cowboy, "~> 2.0"},
      {:sass_compiler, "~> 0.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      update: [
        "cmd rm -rf _build deps mix.lock",
        "deps.get"
      ]
    ]
  end
end
