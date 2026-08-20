# ShadBlazor.FreeIcon

[![CI](https://github.com/clight7664/ShadBlazor.FreeIcon/actions/workflows/ci.yml/badge.svg)](https://github.com/clight7664/ShadBlazor.FreeIcon/actions/workflows/ci.yml)
[![NuGet](https://img.shields.io/nuget/v/ShadBlazor.FreeIcon.svg)](https://www.nuget.org/packages/ShadBlazor.FreeIcon)
[![License: MIT](https://img.shields.io/badge/code-MIT-2ea44f.svg)](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/LICENSE)
[![Artwork: CC BY 4.0](https://img.shields.io/badge/artwork-CC%20BY%204.0-4f46e5.svg)](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/THIRD-PARTY-NOTICES.md)

Strongly typed, accessible, JavaScript-free SVG icons for Blazor. The package embeds
all **1,544 canonical Lets Icons** and targets .NET 8, .NET 9 and .NET 10.

中文维护入口：[从这里开始](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/00-START-HERE.zh-CN.md)

## Highlights

- 1,544 icons with generated `FreeIcons.*` properties and dynamic name lookup.
- Blazor WebAssembly, Blazor Server and Blazor Web App support.
- `currentColor`, CSS/Tailwind classes and standard SVG attributes.
- Accessible decorative and labelled rendering modes.
- Indexed category/variant filtering and stable paged catalog queries.
- Per-instance SVG ID rewriting to avoid `id`, `url(...)` and `href` collisions.
- Deterministic, pinned generation from `@iconify-json/lets-icons` 1.2.2.
- Responsive preview browser with search, filters, metadata and copy-ready samples.

## Install

```shell
dotnet add package ShadBlazor.FreeIcon --version 1.0.0
```

Add the namespace to `_Imports.razor`:

```razor
@using ShadBlazor.FreeIcon
```

## Render icons

Use the strongly typed API when the icon is known at compile time:

```razor
<FreeIcon Icon="@FreeIcons.Search" Size="24px" />
```

Use a canonical kebab-case name for data-driven UI:

```razor
<FreeIcon Name="search" Size="1.5rem" Color="currentColor" />
```

Styling and accessible labels use ordinary component parameters:

```razor
<FreeIcon Icon="@FreeIcons.Home"
          Class="text-indigo-600 dark:text-indigo-300"
          Decorative="false"
          Title="Home" />
```

The component accepts `Width`, `Height`, `Size`, `Class`, `Style`, `Color`, `Title`,
`AriaLabel`, `Decorative`, `PreserveAspectRatio` and unmatched SVG attributes.
Unlabelled icons are decorative by default. A non-decorative icon falls back to its
catalog name when neither `Title` nor `AriaLabel` is provided.

## Query the catalog

```csharp
var icon = FreeIconRegistry.Get("search");

if (FreeIconRegistry.TryGet(userInput, out var selected))
{
    // selected is an immutable FreeIconData instance
}

var page = FreeIconRegistry.Query(new FreeIconQuery
{
    Text = "arrow",
    Category = "Arrow",
    Variant = FreeIconVariant.Light,
    Skip = 0,
    Take = 48
});

Console.WriteLine($"Showing {page.Items.Count} of {page.TotalCount}");
```

Compatibility helpers include `Search`, `InCategory`, `InVariant`, `All`, `Names`,
`Categories` and `Variants`. Name and category matching is case-insensitive.

## Repository layout

```text
src/ShadBlazor.FreeIcon/                 NuGet Razor class library
preview/ShadBlazor.FreeIcon.Preview/     Blazor WebAssembly catalog browser
tools/ShadBlazor.FreeIcon.Verifier/      compiled architecture/catalog verifier
tools/icons/                             deterministic source and code generation
tools/quality/                           repository and package checks
tools/commands/                          canonical Windows/Linux command entrypoints
eng/                                     short compatibility wrappers
configs/                                 Tailwind and editor/build configuration
docs/                                    user, maintainer and release manuals
.github/workflows/                       CI, Pages preview and NuGet release workflows
```

The solution contains only the library, preview and compiled verifier projects.
Generated artifacts stay under `bin/`, `obj/`, `artifacts/` and `release/packages/`
and are intentionally excluded from Git.

## Develop locally

Requirements: .NET SDK 10.x, the .NET 8/9/10 targeting packs, Node.js 20+ and npm.

```powershell
tools\commands\doctor.cmd
tools\commands\bootstrap.cmd
tools\commands\dev.cmd
```

The preview opens at `http://localhost:5188`. For individual checks:

```powershell
npm run verify
dotnet build ShadBlazor.FreeIcon.sln -c Release
dotnet run --project tools\ShadBlazor.FreeIcon.Verifier -c Release
```

## Build a release

```powershell
scripts\release\release.cmd 1.0.0
```

This restores, synchronizes the pinned icon source, verifies the generated catalog,
builds all targets, creates `.nupkg`/`.snupkg` files and inspects package contents.
The complete maintainer and NuGet.org checklist is in
[complete release manual](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/09-ICON-ARCHITECTURE-AND-NUGET-RELEASE.zh-CN.md).

## Documentation

| Document | Purpose |
| --- | --- |
| [User guide](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/01-USER-GUIDE.zh-CN.md) | component parameters and catalog APIs |
| [Maintainer guide](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/02-MAINTAINER-GUIDE.zh-CN.md) | generation, validation and maintenance |
| [Preview guide](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/03-PREVIEW-TAILWIND-WASM.zh-CN.md) | WASM preview and Tailwind workflow |
| [CI/CD](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/04-CI-CD.zh-CN.md) | GitHub Actions and Pages |
| [Solution organization](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/06-SOLUTION-ORGANIZATION.zh-CN.md) | directory ownership and boundaries |
| [Release manual](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/09-ICON-ARCHITECTURE-AND-NUGET-RELEASE.zh-CN.md) | architecture and NuGet publication |
| [License and design provenance](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/docs/10-LICENSE-AND-DESIGN-PROVENANCE.zh-CN.md) | third-party attribution and UI originality |

## Licenses and attribution

The ShadBlazor.FreeIcon source code, build tooling and preview implementation are
licensed under the [MIT License](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/LICENSE).

The embedded **Lets Icons** artwork is © Leonid Tsvetkov and licensed under
[Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/).
See [THIRD-PARTY-NOTICES.md](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/THIRD-PARTY-NOTICES.md) and
[PACKAGE-LICENSE.txt](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/PACKAGE-LICENSE.txt). ShadBlazor.FreeIcon does not claim
ownership of the original artwork or imply endorsement by its author.

The preview UI is an original Blazor/Tailwind implementation under this repository's
identity. External interface references were used only to study general information
architecture; no third-party logo, screenshot, source code or branded copy is shipped.

## Contributing and security

See [CONTRIBUTING.md](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/CONTRIBUTING.md) before submitting changes. Report security
issues using the process in [SECURITY.md](https://github.com/clight7664/ShadBlazor.FreeIcon/blob/main/SECURITY.md).
