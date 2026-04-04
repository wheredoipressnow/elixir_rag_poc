defmodule RagPoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :rag_poc,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:langchain, "~> 0.7"},
      {:req, "~> 0.5"},
      {:nimble_csv, "~> 1.3"}
    ]
  end
end
