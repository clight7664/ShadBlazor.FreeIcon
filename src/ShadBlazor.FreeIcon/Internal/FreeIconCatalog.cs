using System.Diagnostics.CodeAnalysis;
using System.Text.Json;

namespace ShadBlazor.FreeIcon;

internal static class FreeIconCatalog
{
    private const string ResourceName = "ShadBlazor.FreeIcon.Resources.lets-icons.json";
    private static readonly Lazy<CatalogState> State = new(Load, isThreadSafe: true);

    public static IReadOnlyList<FreeIconData> All => State.Value.All;
    public static IReadOnlyList<string> Names => State.Value.Names;
    public static IReadOnlyList<string> Categories => State.Value.Categories;
    public static IReadOnlyList<FreeIconVariant> Variants => State.Value.Variants;

    public static FreeIconData Get(string name)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);

        if (State.Value.ByName.TryGetValue(name.Trim(), out var icon))
        {
            return icon;
        }

        throw new KeyNotFoundException(
            $"Unknown icon '{name}'. Use FreeIconRegistry.Names or FreeIconRegistry.Search(...) to discover valid names.");
    }

    public static bool TryGet(string? name, [NotNullWhen(true)] out FreeIconData? icon)
    {
        icon = null;
        if (string.IsNullOrWhiteSpace(name))
        {
            return false;
        }

        if (State.Value.ByName.TryGetValue(name.Trim(), out var found))
        {
            icon = found;
            return true;
        }

        return false;
    }

    public static IReadOnlyList<FreeIconData> Search(string? query, int maxResults)
    {
        if (maxResults <= 0)
        {
            return Array.Empty<FreeIconData>();
        }

        return Query(new FreeIconQuery { Text = query, Take = maxResults }).Items;
    }

    public static IReadOnlyList<FreeIconData> InCategory(string? category)
    {
        if (string.IsNullOrWhiteSpace(category))
        {
            return Array.Empty<FreeIconData>();
        }

        return State.Value.ByCategory.TryGetValue(category.Trim(), out var icons)
            ? icons
            : Array.Empty<FreeIconData>();
    }

    public static IReadOnlyList<FreeIconData> InVariant(FreeIconVariant variant) =>
        State.Value.ByVariant.TryGetValue(variant, out var icons)
            ? icons
            : Array.Empty<FreeIconData>();

    public static FreeIconQueryResult Query(FreeIconQuery query)
    {
        ArgumentOutOfRangeException.ThrowIfNegative(query.Skip);
        ArgumentOutOfRangeException.ThrowIfNegative(query.Take);

        IEnumerable<FreeIconData> candidates = State.Value.All;
        if (!string.IsNullOrWhiteSpace(query.Category))
        {
            candidates = State.Value.ByCategory.TryGetValue(query.Category.Trim(), out var categoryIcons)
                ? categoryIcons
                : Array.Empty<FreeIconData>();
        }

        if (query.Variant is { } variant)
        {
            if (!State.Value.ByVariant.TryGetValue(variant, out var variantIcons))
            {
                candidates = Array.Empty<FreeIconData>();
            }
            else if (string.IsNullOrWhiteSpace(query.Category))
            {
                candidates = variantIcons;
            }
            else
            {
                var variantNames = variantIcons.Select(icon => icon.Name).ToHashSet(StringComparer.OrdinalIgnoreCase);
                candidates = candidates.Where(icon => variantNames.Contains(icon.Name));
            }
        }

        var normalizedText = query.Text?.Trim();
        FreeIconData[] matches;
        if (string.IsNullOrWhiteSpace(normalizedText))
        {
            matches = candidates.OrderBy(icon => icon.Name, StringComparer.OrdinalIgnoreCase).ToArray();
        }
        else
        {
            matches = candidates
                .Select(icon => new { Icon = icon, Score = Score(icon, normalizedText) })
                .Where(match => match.Score >= 0)
                .OrderBy(match => match.Score)
                .ThenBy(match => match.Icon.Name, StringComparer.OrdinalIgnoreCase)
                .Select(match => match.Icon)
                .ToArray();
        }

        var items = query.Take == 0
            ? Array.Empty<FreeIconData>()
            : matches.Skip(query.Skip).Take(query.Take).ToArray();

        return new FreeIconQueryResult(items, matches.Length, query.Skip, query.Take);
    }

    private static int Score(FreeIconData icon, string query)
    {
        if (icon.Name.Equals(query, StringComparison.OrdinalIgnoreCase)) return 0;
        if (icon.CSharpPropertyName.Equals(query, StringComparison.OrdinalIgnoreCase)) return 1;
        if (icon.Name.StartsWith(query, StringComparison.OrdinalIgnoreCase)) return 1;
        if (icon.CSharpPropertyName.StartsWith(query, StringComparison.OrdinalIgnoreCase)) return 2;
        if (icon.Name.Contains(query, StringComparison.OrdinalIgnoreCase)) return 3;
        if (icon.CSharpPropertyName.Contains(query, StringComparison.OrdinalIgnoreCase)) return 4;
        if (icon.Categories.Any(category => category.Contains(query, StringComparison.OrdinalIgnoreCase))) return 5;
        return -1;
    }

    private static CatalogState Load()
    {
        var assembly = typeof(FreeIconCatalog).Assembly;
        using var stream = assembly.GetManifestResourceStream(ResourceName)
            ?? throw new InvalidOperationException(
                $"Embedded icon resource '{ResourceName}' was not found. " +
                "Run tools/commands/bootstrap.cmd and rebuild the solution.");

        using var document = JsonDocument.Parse(stream);
        var root = document.RootElement;
        var defaultWidth = ReadInt(root, "width", 24);
        var defaultHeight = ReadInt(root, "height", 24);
        var defaultLeft = ReadInt(root, "left", 0);
        var defaultTop = ReadInt(root, "top", 0);
        var categoriesByIcon = BuildCategoryIndex(root);

        if (!root.TryGetProperty("icons", out var iconsElement) || iconsElement.ValueKind != JsonValueKind.Object)
        {
            throw new InvalidOperationException("The embedded Iconify JSON has no 'icons' object.");
        }

        var byName = new Dictionary<string, FreeIconData>(StringComparer.OrdinalIgnoreCase);

        foreach (var property in iconsElement.EnumerateObject())
        {
            var iconJson = property.Value;
            if (!iconJson.TryGetProperty("body", out var bodyElement) || bodyElement.ValueKind != JsonValueKind.String)
            {
                continue;
            }

            categoriesByIcon.TryGetValue(property.Name, out var iconCategories);
            byName[property.Name] = new FreeIconData(
                property.Name,
                bodyElement.GetString() ?? string.Empty,
                ReadInt(iconJson, "width", defaultWidth),
                ReadInt(iconJson, "height", defaultHeight),
                ReadInt(iconJson, "left", defaultLeft),
                ReadInt(iconJson, "top", defaultTop),
                iconCategories ?? Array.Empty<string>(),
                ReadString(iconJson, "csharpProperty", property.Name));
        }

        var all = byName.Values
            .OrderBy(icon => icon.Name, StringComparer.OrdinalIgnoreCase)
            .ToArray();
        var names = all.Select(icon => icon.Name).ToArray();
        var categoryNames = all
            .SelectMany(icon => icon.Categories)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(category => category, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        var byCategory = categoryNames.ToDictionary(
            category => category,
            category => (IReadOnlyList<FreeIconData>)all
                .Where(icon => icon.Categories.Contains(category, StringComparer.OrdinalIgnoreCase))
                .ToArray(),
            StringComparer.OrdinalIgnoreCase);

        var byVariant = all
            .GroupBy(icon => icon.Variant)
            .ToDictionary(
                group => group.Key,
                group => (IReadOnlyList<FreeIconData>)group.ToArray());
        var variants = byVariant.Keys.OrderBy(variant => variant).ToArray();

        return new CatalogState(byName, byCategory, byVariant, all, names, categoryNames, variants);
    }

    private static Dictionary<string, IReadOnlyList<string>> BuildCategoryIndex(JsonElement root)
    {
        var temp = new Dictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase);
        if (!root.TryGetProperty("categories", out var categoriesElement) ||
            categoriesElement.ValueKind != JsonValueKind.Object)
        {
            return new Dictionary<string, IReadOnlyList<string>>(StringComparer.OrdinalIgnoreCase);
        }

        foreach (var categoryProperty in categoriesElement.EnumerateObject())
        {
            if (categoryProperty.Value.ValueKind != JsonValueKind.Array)
            {
                continue;
            }

            foreach (var iconNameElement in categoryProperty.Value.EnumerateArray())
            {
                var iconName = iconNameElement.GetString();
                if (string.IsNullOrWhiteSpace(iconName))
                {
                    continue;
                }

                if (!temp.TryGetValue(iconName, out var list))
                {
                    list = new List<string>();
                    temp[iconName] = list;
                }

                list.Add(categoryProperty.Name.Trim());
            }
        }

        return temp.ToDictionary(
            pair => pair.Key,
            pair => (IReadOnlyList<string>)pair.Value
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToArray(),
            StringComparer.OrdinalIgnoreCase);
    }

    private static string ReadString(JsonElement element, string propertyName, string fallback) =>
        element.TryGetProperty(propertyName, out var value) && value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? fallback
            : fallback;

    private static int ReadInt(JsonElement element, string propertyName, int fallback) =>
        element.TryGetProperty(propertyName, out var value) &&
        value.ValueKind == JsonValueKind.Number &&
        value.TryGetInt32(out var number)
            ? number
            : fallback;

    private sealed record CatalogState(
        IReadOnlyDictionary<string, FreeIconData> ByName,
        IReadOnlyDictionary<string, IReadOnlyList<FreeIconData>> ByCategory,
        IReadOnlyDictionary<FreeIconVariant, IReadOnlyList<FreeIconData>> ByVariant,
        IReadOnlyList<FreeIconData> All,
        IReadOnlyList<string> Names,
        IReadOnlyList<string> Categories,
        IReadOnlyList<FreeIconVariant> Variants);
}
