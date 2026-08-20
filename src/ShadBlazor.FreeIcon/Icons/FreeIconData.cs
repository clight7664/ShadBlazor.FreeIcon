namespace ShadBlazor.FreeIcon;

/// <summary>Immutable metadata and trusted SVG body for a Lets Icons glyph.</summary>
public sealed class FreeIconData
{
    internal FreeIconData(
        string name,
        string body,
        int width,
        int height,
        int left,
        int top,
        IReadOnlyList<string> categories,
        string cSharpPropertyName)
    {
        Name = name;
        Body = body;
        Width = width;
        Height = height;
        Left = left;
        Top = top;
        Categories = categories;
        CSharpPropertyName = cSharpPropertyName;
        Variant = InferVariant(name);
    }

    public string Name { get; }
    public int Width { get; }
    public int Height { get; }
    public int Left { get; }
    public int Top { get; }
    public IReadOnlyList<string> Categories { get; }
    public string CSharpPropertyName { get; }
    public FreeIconVariant Variant { get; }
    public string ViewBox => $"{Left} {Top} {Width} {Height}";
    public double AspectRatio => (double)Width / Height;

    internal string Body { get; }

    public override string ToString() => Name;

    private static FreeIconVariant InferVariant(string name)
    {
        if (name.EndsWith("-broken-line", StringComparison.OrdinalIgnoreCase))
        {
            return FreeIconVariant.BrokenLine;
        }

        if (name.EndsWith("-duotone-line", StringComparison.OrdinalIgnoreCase))
        {
            return FreeIconVariant.DuotoneLine;
        }

        if (name.EndsWith("-duotone", StringComparison.OrdinalIgnoreCase))
        {
            return FreeIconVariant.Duotone;
        }

        if (name.EndsWith("-fill", StringComparison.OrdinalIgnoreCase))
        {
            return FreeIconVariant.Fill;
        }

        if (name.EndsWith("-light", StringComparison.OrdinalIgnoreCase))
        {
            return FreeIconVariant.Light;
        }

        return FreeIconVariant.Regular;
    }
}
