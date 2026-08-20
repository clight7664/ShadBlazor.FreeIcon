# ShadBlazor.FreeIcon 项目实施总结文档

## 当前本地落地状态（2026-08-20）

- 稳定版本已升级为 `1.0.0`。
- 1544 个 Lets Icons 真实资源及强类型 API 已完整落地。
- 核心层已形成 `FreeIcon` 渲染组件、不可变 `FreeIconData`、延迟加载目录、
  分类/变体预索引、强类型 `FreeIcons`、动态 `FreeIconRegistry` 与统一分页查询模型。
- SVG 渲染支持 `currentColor`、可访问性自动模式、尺寸/样式/透传属性，以及每实例
  `id`、`url(...)`、`href`、`xlink:href` 隔离。
- .NET 8 / 9 / 10 全目标框架构建通过，1544 图标编译验证通过。
- `/icons` 已使用真实目录查询，搜索与变体组合筛选已在本地 WASM 预览中验证。
- `ShadBlazor.FreeIcon.1.0.0.nupkg` 与 `.snupkg` 已生成到 `release/packages`，
  nuspec、README、许可声明、三目标框架 DLL 与符号包已验证。
- NuGet.org 正式上传需要维护者登录或提供作用域限定的 `NUGET_API_KEY`。

## 一、项目目标

将 Figma Free Icon Pack / Lets Icons 资源工程化封装为开源 Blazor Icon
组件库。

项目名称：

`ShadBlazor.FreeIcon`

目标：

-   Blazor 原生 SVG Icon Library
-   支持 .NET 8 / .NET 9 / .NET 10
-   支持 Blazor WebAssembly
-   支持 NuGet 发布
-   提供类似 Lucide 的 Docs Preview 网站
-   当前 Icon 数量：1544

------------------------------------------------------------------------

## 二、技术方案

技术栈：

-   .NET 10 SDK
-   Blazor WebAssembly
-   Razor Class Library
-   Tailwind CSS v4
-   Strongly Typed C# API
-   SVG currentColor 渲染

设计原则：

-   Icon Library 不依赖 JavaScript Runtime
-   SVG 本地资源
-   支持主题切换
-   支持无障碍访问

------------------------------------------------------------------------

## 三、最终仓库结构

``` text
ShadBlazor.FreeIcon

├── src
│   └── ShadBlazor.FreeIcon
│
├── preview
│   └── ShadBlazor.FreeIcon.Preview
│
├── tools
│   ├── Generator
│   └── Verifier
│
├── scripts
│   ├── environment
│   ├── generate
│   ├── build
│   ├── preview
│   ├── package
│   ├── release
│   └── github
│
├── configs
│
├── docs
│
├── release
│
├── README.md
├── LICENSE
└── THIRD-PARTY-NOTICES.md
```

------------------------------------------------------------------------

## 四、Preview Docs Site

Preview 按照 Lucide / shadcn 风格设计。

路由：

  路由         功能
  ------------ --------------
  `/`          首页介绍
  `/icons`     Icon Browser
  `/usage`     使用文档
  `/license`   版权说明

首页包含：

-   Hero 区域
-   安装方式
-   特性介绍
-   快速开始

------------------------------------------------------------------------

## 五、Icon Browser

核心能力：

-   搜索
-   Category 过滤
-   Variant 过滤
-   Card 模式
-   List 模式
-   Sticky Toolbar
-   Skeleton Loading
-   Virtualize
-   Icon Detail Dialog
-   Copy Razor Code

性能目标：

1544 Icons 不一次性生成全部 DOM。

采用：

``` text
Icon Registry

↓

Search Service

↓

Filter

↓

Virtualize

↓

Visible SVG Items
```

------------------------------------------------------------------------

## 六、主题系统

支持：

-   Light Mode
-   Dark Mode
-   System Theme

实现：

-   Tailwind dark class strategy
-   CSS Variables Token
-   Theme Provider
-   Theme Toggle

------------------------------------------------------------------------

## 七、版权设计

源码：

MIT License

------------------------------------------------------------------------

Icon Artwork：

Lets Icons

Author:

Leonid Tsvetkov

License:

Creative Commons Attribution 4.0 International

(CC BY 4.0)

------------------------------------------------------------------------

原则：

-   不声明原始 Icon 版权
-   保留第三方声明
-   LICENSE 与 THIRD-PARTY-NOTICES 分离

------------------------------------------------------------------------

## 八、脚本体系

目录：

``` text
scripts

├── environment
│   └── doctor.cmd

├── generate
│   ├── sync-icons.cmd
│   └── generate-api.cmd

├── build
│   ├── clean.cmd
│   └── build.cmd

├── preview
│   └── run.cmd

├── package
│   └── pack.cmd

├── release
│   ├── release.cmd
│   └── push-nuget.cmd

└── github
    ├── ci.yml
    ├── release.yml
    └── pages.yml
```

------------------------------------------------------------------------

## 九、NuGet 发布流程

流程：

``` text
doctor

↓

generate icons

↓

verify

↓

build Release

↓

pack

↓

publish
```

输出：

``` text
release/packages

ShadBlazor.FreeIcon.x.x.x.nupkg
ShadBlazor.FreeIcon.x.x.x.snupkg
```

------------------------------------------------------------------------

## 十、最终版本

最终目标：

`ShadBlazor.FreeIcon.Final.zip`

包含：

-   完整 Solution
-   Preview Docs Site
-   Icon Browser
-   Dark Mode
-   Tailwind Theme
-   NuGet Metadata
-   GitHub Actions
-   Release Pipeline

------------------------------------------------------------------------

## 十一、后续方向

继续完善：

-   自动 Icon 同步
-   单元测试
-   Snapshot 测试
-   API 文档生成
-   GitHub Pages 部署
-   NuGet 正式发布
-   Demo 示例扩展
