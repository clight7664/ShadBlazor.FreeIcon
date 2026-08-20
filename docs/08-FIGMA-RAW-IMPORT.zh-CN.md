# 08 - Figma Raw 导入

Canonical NuGet 默认使用 Iconify 维护的 1544 个 Lets Icons。若你需要逐个保留原 Figma 当前页的 1932 个 Component，可使用：

```text
tools/FigmaRawExporter
```

在 Figma Desktop：Plugins → Development → Import plugin from manifest，选择：

```text
tools/FigmaRawExporter/manifest.json
```

导出 JSON 后：

```powershell
tools\commands\sync-figma.cmd C:\Downloads\shadblazor-freeicon-figma-export.json
```

Raw 模式会处理重复名称：先使用原名称；冲突时加入 Section；仍冲突时加入 Figma Node ID 哈希。生成映射文件：

```text
docs/icon-name-map.figma.json
```

公开 NuGet 建议继续采用 canonical 1544；Raw 1932 更适合作为设计保真/内部构建模式。
