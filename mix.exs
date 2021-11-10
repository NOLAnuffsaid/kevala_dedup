defmodule KevalaDedup.MixProject do
  use Mix.Project

  def project do
    [
      app: :kevala_dedup,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mox, "~> 1.0.1", only: :test},
      {:stream_data, "~> 0.5.0", only: :test},
      {:csv, "~> 2.4"}
    ]
  end
end
