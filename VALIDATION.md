# Validation Status

Validated locally on 2026-08-20 with .NET SDK 10.0.400, the installed .NET 8/9/10
targeting packs, Node.js and the pinned npm toolchain.

## Stable-release checks

1. `npm run verify` passed:
   - repository project-model checks;
   - all 1544 canonical icons from `@iconify-json/lets-icons` 1.2.2;
   - 44 categories;
   - SVG safety patterns;
   - generated C# identifier uniqueness.
2. `dotnet build ShadBlazor.FreeIcon.sln -c Release` passed with zero warnings and
   zero errors for the library's `net8.0`, `net9.0` and `net10.0` targets, the
   verifier and the Blazor WebAssembly preview.
3. The compiled verifier passed and checks:
   - catalog count, names, dimensions and required well-known icons;
   - case-insensitive dynamic lookup and strongly typed instance identity;
   - category and variant indexes;
   - combined text/variant/category filtering and paging;
   - SVG ID rewriting for single/double quoted IDs, `url(...)`, `href` and
     `xlink:href` references.
4. The local `/icons` route loaded all 1544 catalog entries. Searching `arrow` with
   the `Light` variant produced 43 matching icons and rendered only those results.
   Browser-driven checks also verified `home` search (5 matches), selection-driven
   metadata/code updates, dark mode, and the Usage and License routes.
5. `scripts/release/release.cmd 1.0.0` completed and the package verifier confirmed:
   - package ID and version;
   - README, MIT license, composite package license and third-party notices;
   - assemblies for `net8.0`, `net9.0` and `net10.0`;
   - symbol package PDBs.
6. A clean .NET 8 Razor class library used an isolated empty global-packages folder,
   mapped `ShadBlazor.FreeIcon` exclusively to `release/packages`, restored other
   Microsoft dependencies from NuGet.org, and compiled strongly typed, dynamic-name,
   accessible-label and query API usage with zero warnings and zero errors.

Release source commit embedded in the package nuspec:

```text
66f8865f64a58f82a0a04d8e22f98607d659ae84
```

## Release artifacts

```text
release/packages/ShadBlazor.FreeIcon.1.0.0.nupkg
release/packages/ShadBlazor.FreeIcon.1.0.0.snupkg
```

SHA-256:

```text
4820A6FBF69F8DDBD24B9F6641B5D7C90F9482A6FC45C0D5EBB480585B0FE032  ShadBlazor.FreeIcon.1.0.0.nupkg
A3E6D4D24E916F8CC3BAC383FE68B605B193C799EEC0C400ABEE1570878C057F  ShadBlazor.FreeIcon.1.0.0.snupkg
```

## NuGet.org publication

The main package was submitted through the authenticated NuGet.org Upload workflow
on 2026-08-20. NuGet.org completed package validation and public indexing, and the
published page is:

```text
https://www.nuget.org/packages/ShadBlazor.FreeIcon/1.0.0
```

A clean public-source smoke test then restored
`ShadBlazor.FreeIcon/1.0.0` directly from
`https://api.nuget.org/v3/index.json`. NuGet returned the indexed version and the
package content hash, confirming that consumers can install the public release.

The `.snupkg` remains a locally verified release artifact. The browser Upload
workflow published the main `.nupkg` only; publishing symbols requires the scoped
NuGet V3 API-key flow documented in
`docs/09-ICON-ARCHITECTURE-AND-NUGET-RELEASE.zh-CN.md`.
