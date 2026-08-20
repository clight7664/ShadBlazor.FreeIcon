namespace ShadBlazor.FreeIcon;

/// <summary>Describes a catalog query with optional text, category and variant filters.</summary>
public sealed record FreeIconQuery
{
    /// <summary>Text matched against icon names, generated C# property names and categories.</summary>
    public string? Text { get; init; }

    /// <summary>Exact category name, compared case-insensitively.</summary>
    public string? Category { get; init; }

    /// <summary>Optional icon style variant.</summary>
    public FreeIconVariant? Variant { get; init; }

    /// <summary>Number of matching icons to skip. Default: 0.</summary>
    public int Skip { get; init; }

    /// <summary>Maximum number of matching icons to return. Default: 100.</summary>
    public int Take { get; init; } = 100;
}
