defmodule AppManifestTest do
  use ExUnit.Case, async: true

  test "build/1" do
    assert AppManifest.build([:app_manifest]) == [
             {AppManifest, %{since: "0.1.0"},
              [
                {:function, :build, 1, %{since: "0.1.0"}},
                {:function, :to_iodata, 1, %{}},
                {:type, :app, 0, %{}},
                {:type, :entry, 0, %{}},
                {:type, :manifest, 0, %{}},
                {:type, :metadata, 0, %{}}
              ]},
             {Mix.Tasks.AppManifest, %{}, []}
           ]
  end

  test "to_iodata/1" do
    string =
      [:app_manifest]
      |> AppManifest.build()
      |> AppManifest.to_iodata()
      |> IO.iodata_to_binary()

    assert string == """
           AppManifest (since: 0.1.0)
           AppManifest.build/1 (since: 0.1.0)
           AppManifest.to_iodata/1
           t:AppManifest.app/0
           t:AppManifest.entry/0
           t:AppManifest.manifest/0
           t:AppManifest.metadata/0
           Mix.Tasks.AppManifest
           """
  end
end
