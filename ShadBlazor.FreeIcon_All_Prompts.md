# ShadBlazor.FreeIcon 项目实施提示词汇总

## 文档说明

本文档整理本次 ShadBlazor.FreeIcon
项目实施过程中使用的核心提示词（Prompt），用于后续继续开发、复用、交接。

目标：

-   重新构建完整开源 Blazor Icon Library
-   基于 1544 个 Icon 资源
-   建立 Docs Site
-   建立 NuGet 发布体系
-   建立 CI/CD 流程

------------------------------------------------------------------------

# 1. 项目初始化 Prompt

## Prompt

创建一个完整开源项目：

项目名称：

`ShadBlazor.FreeIcon`

目标：

将 Figma Free Icon Pack / Lets Icons 转换为 Blazor Icon 组件库。

要求：

-   提供 Blazor 原生组件
-   支持 .NET 8/9/10
-   支持 Blazor WebAssembly
-   支持 Blazor Server
-   提供强类型 C# Icon API
-   支持动态 Name 查询
-   支持 SVG currentColor
-   支持 Tailwind CSS
-   支持 NuGet 发布

------------------------------------------------------------------------

# 2. 项目架构设计 Prompt

## Prompt

设计完整开源仓库结构。

要求：

包含：

-   src
-   preview
-   tools
-   scripts
-   configs
-   docs
-   release

生成：

-   Solution
-   项目引用关系
-   Build 配置
-   NuGet 配置
-   GitHub Actions

目标结构：

    ShadBlazor.FreeIcon

    src
    preview
    tools
    scripts
    configs
    docs
    release

------------------------------------------------------------------------

# 3. Icon Library 实现 Prompt

## Prompt

实现 ShadBlazor.FreeIcon 核心组件库。

要求：

支持：

``` razor
<FreeIcon Icon="@FreeIcons.Search" />
```

以及：

``` razor
<FreeIcon Name="search" />
```

实现：

-   FreeIcon Component
-   FreeIconRegistry
-   FreeIconCatalog
-   Generated API
-   SVG Resource Management

当前 Icon：

1544 个。

------------------------------------------------------------------------

# 4. Preview Docs Site Prompt

## Prompt

创建类似 Lucide.dev 的文档站点。

要求：

使用：

-   Blazor WASM
-   Tailwind CSS v4

页面：

    /
    Home

    /icons
    Icon Browser

    /usage
    Usage

    /license
    License

Home 页面包含：

-   Hero
-   Feature
-   Installation
-   Quick Start

------------------------------------------------------------------------

# 5. Home 页面设计 Prompt

## Prompt

参考 Lucide 官方网站设计首页。

要求：

顶部：

-   Logo
-   Navigation
-   Github Link
-   Theme Toggle

Hero：

展示：

    ShadBlazor.FreeIcon

    1544 icons for Blazor

提供：

-   Browse Icons
-   Documentation

------------------------------------------------------------------------

# 6. Icon Browser Prompt

## Prompt

实现完整 Icon Browser。

要求：

支持：

-   Search
-   Category Filter
-   Variant Filter
-   Card View
-   List View
-   Sticky Toolbar
-   Size 调节
-   Color 调节
-   Copy Razor
-   Copy Dynamic Usage

布局：

    Header

    Sticky Search Toolbar

    Icon Content

    Footer

------------------------------------------------------------------------

# 7. 性能优化 Prompt

## Prompt

优化 1544 Icon 浏览性能。

要求：

禁止一次性渲染：

    1544 SVG DOM

实现：

-   Virtualize
-   Pagination
-   Lazy Loading
-   Skeleton Loading
-   Search Debounce

目标：

首屏只加载有限 Icon。

------------------------------------------------------------------------

# 8. Card/List 模式 Prompt

## Prompt

Icon Browser 支持两种显示模式。

Card：

用于浏览：

    Icon Preview
    Name
    Variant
    Copy

List：

用于快速搜索：

    Icon
    Name
    Variant
    Action

要求：

统一组件：

    IconCard
    IconListItem
    ViewModeToggle

------------------------------------------------------------------------

# 9. Dark Mode Prompt

## Prompt

实现完整主题系统。

要求：

支持：

-   Light
-   Dark
-   System

技术：

-   Tailwind dark class
-   CSS Variables
-   Theme Provider
-   Theme Toggle

------------------------------------------------------------------------

# 10. Tailwind Theme Prompt

## Prompt

建立统一 Design Token。

包含：

-   background
-   foreground
-   card
-   muted
-   primary
-   border
-   ring

要求：

Preview 和组件库统一。

------------------------------------------------------------------------

# 11. License Prompt

## Prompt

设计开源版权方案。

要求：

代码：

MIT

Icon Artwork：

Lets Icons

Author:

Leonid Tsvetkov

License:

CC BY 4.0

必须：

-   LICENSE 分离
-   THIRD-PARTY-NOTICES
-   不声明原始 Icon 版权所有

------------------------------------------------------------------------

# 12. NuGet 发布 Prompt

## Prompt

建立完整 NuGet 发布流程。

要求：

包含：

-   Package Metadata
-   README
-   License
-   Repository URL
-   Symbol Package

脚本：

    pack.cmd
    release.cmd
    push-nuget.cmd

输出：

    release/packages

------------------------------------------------------------------------

# 13. Build 验证 Prompt

## Prompt

建立自动验证流程。

检查：

-   dotnet SDK
-   node
-   npm
-   git
-   solution
-   projects
-   generated icons

命令：

    doctor.cmd
    build.cmd

------------------------------------------------------------------------

# 14. GitHub CI/CD Prompt

## Prompt

建立 GitHub Actions。

包含：

## CI

执行：

-   restore
-   build
-   test

## Release

Tag:

    v1.0.0

自动：

-   build
-   pack
-   publish NuGet

## Pages

部署 Preview Docs Site。

------------------------------------------------------------------------

# 15. 最终交付 Prompt

## Prompt

生成完整项目仓库。

不要：

-   Patch
-   Fragment
-   Demo

必须：

提供：

    ShadBlazor.FreeIcon.Full.zip

包含：

-   Solution
-   Source
-   Preview
-   Docs
-   Scripts
-   Config
-   Release
-   License

要求：

可以：

    dotnet restore

    dotnet build

    dotnet run

直接运行。

------------------------------------------------------------------------

# 16. 后续增强 Prompt

继续扩展：

-   Icon Favorites
-   URL Search State
-   SVG Export
-   PNG Export
-   API Documentation
-   Automated Icon Sync
-   Snapshot Testing
-   GitHub Pages
-   NuGet Production Release

------------------------------------------------------------------------

# 总结

以上 Prompt 可作为：

-   AI Coding Agent 指令集
-   项目实施规范
-   开源仓库建设方案
-   后续版本迭代输入
