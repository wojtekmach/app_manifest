defmodule AppManifest do
  @moduledoc since: "0.1.0"

  @type app() :: atom()

  @type metadata() :: map()

  @type entry() :: [{kind :: atom(), name :: atom(), arity(), metadata :: map()}]

  @type manifest() :: [{module(), metadata(), [entry()]}]

  @doc since: "0.1.0"
  @spec build([app()]) :: manifest()
  def build(apps) do
    for app <- apps,
        module <- modules(app),
        manifest = manifest(module),
        manifest != :hidden do
      manifest
    end
  end

  @spec to_iodata(manifest()) :: iodata()
  def to_iodata(manifest) do
    kinds = %{
      function: "",
      macro: "",
      type: "t:",
      opaque: "t:",
      callback: "b:",
      macrocallback: "b:"
    }

    for {module, metadata, entries} <- manifest do
      entries =
        for {kind, name, arity, metadata} <- entries do
          [
            Map.fetch!(kinds, kind),
            "#{inspect(module)}.",
            "#{name}/#{arity}",
            metadata_to_string(metadata),
            "\n"
          ]
        end

      [
        inspect(module),
        metadata_to_string(metadata),
        "\n",
        entries
      ]
    end
  end

  defp metadata_to_string(metadata) do
    if metadata == %{} do
      ""
    else
      [
        " (",
        Enum.map_join(metadata, ", ", fn {key, value} ->
          value = if is_binary(value), do: value, else: inspect(value)
          [Atom.to_string(key), ": ", value]
        end),
        ")"
      ]
    end
  end

  defp modules(app) do
    case Application.load(app) do
      :ok ->
        Application.spec(app, :modules)

      {:error, {:already_loaded, _}} ->
        Application.spec(app, :modules)

      {:error, reason} ->
        raise ArgumentError, inspect(reason)
    end
    |> Enum.sort()
  end

  defp manifest(module) do
    case Code.fetch_docs(module) do
      {:docs_v1, _anno, _language, _format, :hidden, _metadata, _} ->
        :hidden

      {:docs_v1, _anno, _language, _format, _, metadata, entries} ->
        entries =
          for {{kind, name, arity}, _anno, _signature, doc, metadata} <- entries,
              doc != :hidden or Map.drop(metadata, [:defaults]) != %{} do
            {kind, name, arity, metadata}
          end
          |> Enum.sort()

        {module, metadata, entries}

      {:error, reason} ->
        reason
    end
  end
end
