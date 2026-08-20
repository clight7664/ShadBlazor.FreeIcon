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
5. `scripts/release/release.cmd 1.0.0` completed and the package verifier confirmed:
   - package ID and version;
   - README, MIT license, composite package license and third-party notices;
   - assemblies for `net8.0`, `net9.0` and `net10.0`;
   - symbol package PDBs.
6. A clean .NET 8 Razor class library installed version 1.0.0 exclusively from
   `release/packages` and compiled strongly typed, dynamic-name and query API usage.

## Release artifacts

```text
release/packages/ShadBlazor.FreeIcon.1.0.0.nupkg
release/packages/ShadBlazor.FreeIcon.1.0.0.snupkg
```

SHA-256:

```text
B2271BA1CC9BE646854636B40BB563A7DB6AF11DF21EB02D6202F6A591E94850  ShadBlazor.FreeIcon.1.0.0.nupkg
C45D43DB6E6811226F8C119F71E1BF87E63F59FA2667807C197989B219FCD5F1  ShadBlazor.FreeIcon.1.0.0.snupkg
```

NuGet.org returned 404 for the package flat-container endpoint before publication,
which confirms that version 1.0.0 was not already visible at validation time.
