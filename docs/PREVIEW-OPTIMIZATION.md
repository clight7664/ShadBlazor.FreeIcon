# Preview Optimization

## Rendering Modes

Card mode:
- visual browsing
- responsive grid

List mode:
- compact view
- fast scanning


## Performance

The browser does not render all 1544 icons immediately.

Strategy:

Initial:
60 icons

Load more:
+60

Virtualize:
Blazor Virtualize component


## Components

IconBrowser/

- IconToolbar.razor
- IconCard.razor
- IconRow.razor
- IconSkeleton.razor
- ViewModeToggle.razor
- LoadingIndicator.razor
