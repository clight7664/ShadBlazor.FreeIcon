# ShadBlazor.FreeIcon

`ShadBlazor.FreeIcon` is a JavaScript-free Blazor SVG icon library containing all
1544 canonical Lets Icons. It supports Blazor WebAssembly, Blazor Server and Blazor
Web Apps on .NET 8, .NET 9 and .NET 10.

## Install

```shell
dotnet add package ShadBlazor.FreeIcon --version 1.0.0
```

Add the namespace to `_Imports.razor`:

```razor
@using ShadBlazor.FreeIcon
```

## Render icons

Use the generated, strongly typed API when the icon is known at compile time:

```razor
<FreeIcon Icon="@FreeIcons.Search" Size="24px" />
```

Use a canonical kebab-case name for configuration-driven icons:

```razor
<FreeIcon Name="search" Size="1.5rem" Color="currentColor" />
```

The component accepts `Width`, `Height`, `Class`, `Style`, `Color`, `Title`,
`AriaLabel`, `Decorative`, `PreserveAspectRatio` and unmatched SVG attributes.
Icons use `currentColor`, so normal CSS and Tailwind text-color utilities work.

```razor
<FreeIcon Icon="@FreeIcons.Home" class="text-indigo-600" AriaLabel="Home" />
```

Unlabelled icons are rendered as decorative (`aria-hidden="true"`). Supplying
`Title` or `AriaLabel` automatically exposes the SVG as an image to assistive
technology. Set `Decorative` explicitly to override the automatic mode.

## Catalog API

```csharp
var icon = FreeIconRegistry.Get("search");

if (FreeIconRegistry.TryGet(userInput, out var selected))
{
    // selected is a stable, immutable FreeIconData instance
}

var firstPage = FreeIconRegistry.Query(new FreeIconQuery
{
    Text = "arrow",
    Category = "Arrow",
    Variant = FreeIconVariant.Light,
    Skip = 0,
    Take = 48
});

Console.WriteLine($"Showing {firstPage.Items.Count} of {firstPage.TotalCount}");
```

Compatibility helpers are also available: `Search`, `InCategory`, `InVariant`,
`All`, `Names`, `Categories` and `Variants`. Lookups and category names are
case-insensitive. Search ranking prefers exact names, generated C# property names,
prefix matches and then category matches.

## Architecture and safety

- The canonical catalog is embedded into the Razor class library; applications do
  not need network access or a JavaScript runtime to render an icon.
- `FreeIconData` is immutable and shared by the strongly typed and dynamic APIs.
- Category and variant indexes are created once when the lazy catalog is loaded.
- SVG content is generated only from the pinned, verified upstream catalog.
- Internal SVG IDs and their `url(...)`, `href` and `xlink:href` references are
  rewritten per component instance to prevent collisions on pages with many icons.

## Source and licenses

Library source code is MIT licensed; see `LICENSE`. The embedded Lets Icons artwork
is by Leonid Tsvetkov and is licensed under CC BY 4.0. See
`THIRD-PARTY-NOTICES.md` and `PACKAGE-LICENSE.txt` in the repository and NuGet package.
