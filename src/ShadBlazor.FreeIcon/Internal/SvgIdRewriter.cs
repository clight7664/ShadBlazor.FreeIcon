using System.Text.RegularExpressions;

namespace ShadBlazor.FreeIcon;

internal static partial class SvgIdRewriter
{
    [GeneratedRegex("\\bid\\s*=\\s*(?<quote>[\\\"'])(?<id>[^\\\"']+)\\k<quote>", RegexOptions.CultureInvariant)]
    private static partial Regex IdRegex();

    public static string Rewrite(string body, string prefix)
    {
        if (string.IsNullOrEmpty(body) || body.IndexOf("id", StringComparison.OrdinalIgnoreCase) < 0)
        {
            return body;
        }

        var ids = IdRegex().Matches(body)
            .Cast<Match>()
            .Select(match => match.Groups["id"].Value)
            .Distinct(StringComparer.Ordinal)
            .OrderByDescending(x => x.Length)
            .ToArray();

        var rewritten = body;
        foreach (var id in ids)
        {
            var replacement = $"{prefix}-{id}";
            var escapedId = Regex.Escape(id);
            rewritten = Regex.Replace(
                rewritten,
                $"(?<prefix>\\bid\\s*=\\s*[\\\"']){escapedId}(?<suffix>[\\\"'])",
                match => $"{match.Groups["prefix"].Value}{replacement}{match.Groups["suffix"].Value}",
                RegexOptions.CultureInvariant);
            rewritten = Regex.Replace(
                rewritten,
                $"(?<prefix>url\\(\\s*[\\\"']?#){escapedId}(?<suffix>[\\\"']?\\s*\\))",
                match => $"{match.Groups["prefix"].Value}{replacement}{match.Groups["suffix"].Value}",
                RegexOptions.CultureInvariant);
            rewritten = Regex.Replace(
                rewritten,
                $"(?<prefix>\\b(?:href|xlink:href)\\s*=\\s*[\\\"']#){escapedId}(?<suffix>[\\\"'])",
                match => $"{match.Groups["prefix"].Value}{replacement}{match.Groups["suffix"].Value}",
                RegexOptions.CultureInvariant);
        }

        return rewritten;
    }
}
