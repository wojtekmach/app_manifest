defmodule AppManifest do
  @moduledoc since: "0.1.0"

  @type app() :: atom()

  @type metadata() :: map()

  @type doc() :: :documented | :none | :hidden

  @type entry() :: [{{kind :: atom(), name :: atom(), arity()}, doc(), metadata()}]

  @type manifest() :: [{module(), doc(), metadata(), [entry()]}]

  @doc since: "0.1.0"
  @spec build([app()]) :: manifest()
  def build(apps) do
    for app <- apps,
        module <- modules(app),
        manifest = manifest(module) do
      manifest
    end
  end

  @spec to_iodata(manifest()) :: iodata()
  def to_iodata(manifest) do
    prefixes = %{
      function: "",
      macro: "",
      type: "t:",
      opaque: "t:",
      callback: "b:",
      macrocallback: "b:"
    }

    for {module, doc, metadata, entries} <- manifest do
      entries =
        for {{kind, name, arity}, doc, metadata} <- entries do
          [
            Map.fetch!(prefixes, kind),
            "#{inspect(module)}.",
            "#{name}/#{arity}",
            " (#{doc})",
            metadata_to_iodata(metadata),
            "\n"
          ]
        end

      [
        inspect(module),
        " (#{doc})",
        metadata_to_iodata(metadata),
        "\n",
        entries
      ]
    end
  end

  defp metadata_to_iodata(metadata) do
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
      {:docs_v1, _anno, _language, _format, doc, metadata, entries} ->
        entries =
          for {{kind, name, arity}, _anno, _signature, doc, metadata} <- entries do
            {{kind, name, arity}, doc(doc), metadata}
          end
          |> Enum.sort()

        if doc == :hidden do
          {module, doc(doc), metadata, []}
        else
          {module, doc(doc), metadata, entries}
        end

      {:error, reason} ->
        reason
    end
  end

  defp doc(:hidden), do: :hidden
  defp doc(:none), do: :none
  defp doc(%{}), do: :documented
end
