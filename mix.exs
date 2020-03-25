defmodule PlugCache.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_cache,
      description: description(),
      version: "0.1.1-rc1",
      elixir: "~> 1.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp description do
    """
    An Elixir plug to cache the response
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {PlugCache.Application, []},
      applications: [:nebulex],
      extra_applications: [:logger],
      env: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nebulex, "~> 1.1.1"},
      {:plug, "~> 1.0"},
      {:benchee, "~> 0.10", only: [:dev, :test], optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :plug_cache,
      files: ["lib", "config", "mix.exs", "README*"],
      maintainers: ["Shuhei Hayashibara"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/shufo/plug_cache"}
    ]
  end

  defp aliases do
    [
      test: ["test --no-start"]
    ]
  end
end
