namespace ShadBlazor.FreeIcon;

/// <summary>A stable page of icons and the total number of matches before paging.</summary>
public sealed class FreeIconQueryResult
{
    internal FreeIconQueryResult(
        IReadOnlyList<FreeIconData> items,
        int totalCount,
        int skip,
        int take)
    {
        Items = items;
        TotalCount = totalCount;
        Skip = skip;
        Take = take;
    }

    public IReadOnlyList<FreeIconData> Items { get; }
    public int TotalCount { get; }
    public int Skip { get; }
    public int Take { get; }
    public bool HasPreviousPage => Skip > 0;
    public bool HasNextPage => Skip + Items.Count < TotalCount;
}
