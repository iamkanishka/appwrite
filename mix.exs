defmodule Appwrite.MixProject do
  use Mix.Project

  def project do
    [
      app: :appwrite,
      version: "0.1.1",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Package information for Hex
      description: "Appwrite package for elixir",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Appwrite.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:poison, "~> 6.0"}
    ]
  end

  defp package do
    [
      name: "appwrite",
      # License, e.g., MIT, Apache 2.0
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/iamkanishka/appwrite"
      },
      maintainers: ["Kanishka Naik"]
    ]
  end
end
