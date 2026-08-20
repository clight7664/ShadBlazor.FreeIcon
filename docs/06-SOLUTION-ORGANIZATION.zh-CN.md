# 06 - 解决方案组织

本版本按 `docs / configs / tools` 的方式整理辅助内容，业务项目只保留在 `src / preview`。

```text
ShadBlazor.FreeIcon.sln
├─ src
│  └─ ShadBlazor.FreeIcon
├─ preview
│  └─ ShadBlazor.FreeIcon.Preview
├─ tools
│  └─ ShadBlazor.FreeIcon.Verifier
│     + commands / generators / Figma exporter / quality scripts
├─ docs
│  └─ *.md
└─ configs
   └─ Tailwind、MSBuild、NuGet、VS Code、GitHub Actions 等 Solution Items
```

物理目录：

```text
src/        NuGet RCL
preview/    Blazor WASM 示例站
configs/    Tailwind 与编辑器说明
tools/      CMD/SH、生成器、验证器、Figma exporter
docs/       中文实施文档
eng/        旧路径兼容转发器
.github/    GitHub Actions
.vscode/    VS Code 配置
```

`Directory.Build.props`、`Directory.Packages.props`、`global.json` 等必须位于根目录，才能让 MSBuild/NuGet 自动发现；它们在 `.sln` 里归入 `configs` Solution Folder。
