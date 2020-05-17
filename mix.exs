defmodule AppManifest.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_manifest,
      version: "0.2.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:mix]
    ]
  end

  defp deps do
    []
  end
end
