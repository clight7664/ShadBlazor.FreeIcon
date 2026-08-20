# Preview Optimization

## Performance

The browser does not render all 1544 icons immediately.

Strategy:

The page uses `FreeIconRegistry.Query` with a fixed page size of 48. Category and
variant candidates come from immutable indexes created once with the catalog. Only
the current page and one selected detail icon are rendered.


## Components

IconBrowser/

- CodeSample.razor
- IconDetails.razor

Shared preview components:

- IconCard.razor
- UsageStep.razor
