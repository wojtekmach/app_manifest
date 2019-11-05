defmodule Mix.Tasks.AppManifest do
  use Mix.Task

  @moduledoc """
  Print manifest for given apps.

  Usage:

      app_manifest APP1 APP2 ...
  """

  @shortdoc "Print manifest for given apps"

  @impl true
  def run([]) do
    IO.puts("""
    Usage:

        app_manifest APP1 APP2 ...
    """)

    System.halt(1)
  end

  def run(args) do
    Mix.Task.run("loadpaths")

    args
    |> Enum.map(&String.to_atom/1)
    |> AppManifest.build()
    |> AppManifest.to_iodata()
    |> IO.write()
  end
end
