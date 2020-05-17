defmodule AppManifestTest do
  use ExUnit.Case, async: true

  test "build/1" do
    assert AppManifest.build([:app_manifest]) == [
             {AppManifest, :none, %{since: "0.1.0"},
              [
                {{:function, :build, 1}, :none, %{since: "0.1.0"}},
                {{:function, :to_iodata, 1}, :none, %{}},
                {{:type, :app, 0}, :none, %{}},
                {{:type, :doc, 0}, :none, %{}},
                {{:type, :entry, 0}, :none, %{}},
                {{:type, :manifest, 0}, :none, %{}},
                {{:type, :metadata, 0}, :none, %{}}
              ]},
             {Mix.Tasks.AppManifest, :documented, %{},
              [
                {{:function, :run, 1}, :hidden, %{}}
              ]}
           ]
  end

  test "to_iodata/1" do
    string =
      [:app_manifest]
      |> AppManifest.build()
      |> AppManifest.to_iodata()
      |> IO.iodata_to_binary()

    assert string == """
           AppManifest (none) (since: 0.1.0)
           AppManifest.build/1 (none) (since: 0.1.0)
           AppManifest.to_iodata/1 (none)
           t:AppManifest.app/0 (none)
           t:AppManifest.doc/0 (none)
           t:AppManifest.entry/0 (none)
           t:AppManifest.manifest/0 (none)
           t:AppManifest.metadata/0 (none)
           Mix.Tasks.AppManifest (documented)
           Mix.Tasks.AppManifest.run/1 (hidden)
           """
  end
end
