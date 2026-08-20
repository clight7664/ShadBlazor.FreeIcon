using System.Diagnostics.CodeAnalysis;

namespace ShadBlazor.FreeIcon;

/// <summary>Dynamic lookup and search API for the complete icon catalog.</summary>
public static class FreeIconRegistry
{
    public static IReadOnlyList<FreeIconData> All => FreeIconCatalog.All;
    public static IReadOnlyList<string> Names => FreeIconCatalog.Names;
    public static IReadOnlyList<string> Categories => FreeIconCatalog.Categories;
    public static IReadOnlyList<FreeIconVariant> Variants => FreeIconCatalog.Variants;

    public static FreeIconData Get(string name) => FreeIconCatalog.Get(name);

    public static bool TryGet(string? name, [NotNullWhen(true)] out FreeIconData? icon) =>
        FreeIconCatalog.TryGet(name, out icon);

    public static IReadOnlyList<FreeIconData> Search(string? query, int maxResults = 100) =>
        FreeIconCatalog.Search(query, maxResults);

    public static IReadOnlyList<FreeIconData> InCategory(string? category) =>
        FreeIconCatalog.InCategory(category);

    public static IReadOnlyList<FreeIconData> InVariant(FreeIconVariant variant) =>
        FreeIconCatalog.InVariant(variant);

    /// <summary>
    /// Filters, ranks and pages the icon catalog in one operation. This is the preferred API
    /// for icon browsers because <see cref="FreeIconQueryResult.TotalCount"/> is computed before paging.
    /// </summary>
    public static FreeIconQueryResult Query(FreeIconQuery query) =>
        FreeIconCatalog.Query(query ?? throw new ArgumentNullException(nameof(query)));
}
