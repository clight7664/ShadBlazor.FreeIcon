using ShadBlazor.FreeIcon;

const int ExpectedCanonicalCount = 1544;

var all = FreeIconRegistry.All;
if (all.Count != ExpectedCanonicalCount)
{
    throw new InvalidOperationException(
        $"Catalog count {all.Count} != expected canonical count {ExpectedCanonicalCount}. " +
        "Run tools/commands/bootstrap.cmd before building a release.");
}

var duplicateNames = FreeIconRegistry.Names
    .GroupBy(name => name, StringComparer.OrdinalIgnoreCase)
    .Where(group => group.Count() > 1)
    .Select(group => group.Key)
    .ToArray();

if (duplicateNames.Length > 0)
{
    throw new InvalidOperationException($"Duplicate public names: {string.Join(", ", duplicateNames)}");
}

var invalidDimensions = all
    .Where(icon => icon.Width <= 0 || icon.Height <= 0)
    .Select(icon => icon.Name)
    .Take(10)
    .ToArray();

if (invalidDimensions.Length > 0)
{
    throw new InvalidOperationException($"Invalid icon dimensions: {string.Join(", ", invalidDimensions)}");
}

foreach (var sample in new[] { "add", "search", "home", "3d-box", "copy", "moon", "sun" })
{
    if (!FreeIconRegistry.TryGet(sample, out var icon) || icon is null)
    {
        throw new InvalidOperationException($"Expected icon '{sample}' is missing.");
    }

    if (string.IsNullOrWhiteSpace(icon.CSharpPropertyName))
    {
        throw new InvalidOperationException($"Icon '{sample}' has no generated C# property name.");
    }
}

if (!ReferenceEquals(FreeIcons.Search, FreeIconRegistry.Get("SEARCH")))
{
    throw new InvalidOperationException("Strongly typed and dynamic APIs did not resolve the same immutable icon instance.");
}

var indexedVariantCount = FreeIconRegistry.Variants
    .Sum(variant => FreeIconRegistry.InVariant(variant).Count);
if (indexedVariantCount != all.Count)
{
    throw new InvalidOperationException(
        $"Variant indexes contain {indexedVariantCount} entries, expected {all.Count}.");
}

var query = FreeIconRegistry.Query(new FreeIconQuery
{
    Text = "arrow",
    Variant = FreeIconVariant.Light,
    Skip = 3,
    Take = 7
});
if (query.Items.Count != Math.Min(7, Math.Max(0, query.TotalCount - 3)) ||
    query.Items.Any(icon => icon.Variant != FreeIconVariant.Light) ||
    query.Items.Any(icon =>
        !icon.Name.Contains("arrow", StringComparison.OrdinalIgnoreCase) &&
        !icon.CSharpPropertyName.Contains("arrow", StringComparison.OrdinalIgnoreCase) &&
        !icon.Categories.Any(category => category.Contains("arrow", StringComparison.OrdinalIgnoreCase))))
{
    throw new InvalidOperationException("Combined text/variant query returned an invalid page.");
}

var category = FreeIconRegistry.Categories[0];
var categoryQuery = FreeIconRegistry.Query(new FreeIconQuery
{
    Category = category.ToUpperInvariant(),
    Take = int.MaxValue
});
if (categoryQuery.TotalCount != FreeIconRegistry.InCategory(category).Count ||
    categoryQuery.Items.Any(icon => !icon.Categories.Contains(category, StringComparer.OrdinalIgnoreCase)))
{
    throw new InvalidOperationException("Category index and combined query results disagree.");
}

var rewritten = SvgIdRewriter.Rewrite(
    "<defs><linearGradient id='paint-0'/><clipPath id=\"clip-0\"/></defs>" +
    "<path fill=\"url('#paint-0')\" clip-path=\"url(#clip-0)\"/>" +
    "<use href='#paint-0'/><use xlink:href=\"#clip-0\"/>",
    "instance");
foreach (var expected in new[]
{
    "id='instance-paint-0'",
    "id=\"instance-clip-0\"",
    "url('#instance-paint-0')",
    "url(#instance-clip-0)",
    "href='#instance-paint-0'",
    "xlink:href=\"#instance-clip-0\""
})
{
    if (!rewritten.Contains(expected, StringComparison.Ordinal))
    {
        throw new InvalidOperationException($"SVG ID rewrite did not produce '{expected}'.");
    }
}

Console.WriteLine(
    $"Verified ShadBlazor.FreeIcon: {all.Count} icons, " +
    $"{FreeIconRegistry.Categories.Count} categories, {FreeIconRegistry.Variants.Count} variants.");
