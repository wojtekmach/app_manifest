# AppManifest

Generates a manifest (a list of public modules, functions, types, and callbacks) for given apps.

## Usage

```
mix archive.install github wojtekmach/app_manifest
asdf shell elixir 1.8.2-otp-22 ; mix app_manifest elixir eex ex_unit iex logger mix > manifest-1.8.txt
asdf shell elixir 1.9.2-otp-22 ; mix app_manifest elixir eex ex_unit iex logger mix > manifest-1.9.txt
git diff --no-index manifest-1.8.txt manifest-1.9.txt
```

```diff
 File.rename/2
+File.rename!/2 (since: 1.9.0)
 File.rm/1
```

## License

Apache-2.0
