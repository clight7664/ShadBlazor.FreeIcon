# 01 - 图标库用户使用文档

## 安装

```powershell
dotnet add package ShadBlazor.FreeIcon
```

## 引入命名空间

```razor
@using ShadBlazor.FreeIcon
```

## 强类型使用

```razor
<FreeIcon Icon="@FreeIcons.Search" />
<FreeIcon Icon="@FreeIcons.Home" Size="24px" />
<FreeIcon Icon="@FreeIcons.AddRoundFill" Size="18px" class="text-blue-600" />
```

强类型 API 在构建仓库时由 `tools/icons/sync-icons.mjs` 自动生成，不手写 1544 个 Razor 文件。

## 动态使用

```razor
<FreeIcon Name="search" />
<FreeIcon Name="search-duotone-line" Size="32px" />
```

```csharp
if (FreeIconRegistry.TryGet(model.IconName, out var icon))
{
    // icon 在 true 分支中已被 nullable flow analysis 识别为非 null。
}
```

## 颜色

图标使用 `currentColor`：

```razor
<FreeIcon Icon="@FreeIcons.Search" Style="color:#2563eb" />
```

或让 CSS/Tailwind 控制：

```razor
<FreeIcon Icon="@FreeIcons.Search" class="text-red-500" />
```

Tailwind 仅用于 Preview，不是 NuGet 图标库依赖。

## 尺寸

```razor
<FreeIcon Icon="@FreeIcons.Search" Size="1em" />
<FreeIcon Icon="@FreeIcons.Search" Size="20px" />
<FreeIcon Icon="@FreeIcons.Search" Width="32px" Height="20px" />
```

`Width/Height` 优先于 `Size`。

## 无障碍

装饰性图标：

```razor
<FreeIcon Icon="@FreeIcons.Search" />
```

默认输出 `aria-hidden="true"`。

有语义的图标：

```razor
<FreeIcon Icon="@FreeIcons.Search" Title="搜索" />
```

此时输出 `role="img"`、`aria-label` 和 `<title>`。

## 搜索与分类

```csharp
var all = FreeIconRegistry.All;
var names = FreeIconRegistry.Names;
var categories = FreeIconRegistry.Categories;
var matches = FreeIconRegistry.Search("arrow", 100);
var media = FreeIconRegistry.InCategory("Media");
var page = FreeIconRegistry.Query(new FreeIconQuery
{
    Text = "arrow",
    Category = "Arrow",
    Variant = FreeIconVariant.Light,
    Skip = 0,
    Take = 48
});
```
