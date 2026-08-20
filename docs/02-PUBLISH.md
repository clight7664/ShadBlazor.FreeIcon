# Publish

The stable release pipeline is:

```text
doctor -> generate -> verify -> build -> pack -> inspect -> push NuGet
```

Build and inspect version 1.0.0:

```powershell
scripts\release\release.cmd 1.0.0
```

This creates and validates:

```text
release/packages/ShadBlazor.FreeIcon.1.0.0.nupkg
release/packages/ShadBlazor.FreeIcon.1.0.0.snupkg
```

Publish to NuGet.org using an environment variable so the key is not stored in the repository:

```powershell
$env:NUGET_API_KEY = '<NuGet API key scoped to ShadBlazor.FreeIcon>'
scripts\release\push-nuget.cmd 1.0.0
```

The push command uses NuGet.org, includes the symbol package and enables
`--skip-duplicate`. The CI release workflow performs the same build and package
verification when a `v1.0.0` tag is pushed, then publishes when the repository
secret `NUGET_API_KEY` exists.
