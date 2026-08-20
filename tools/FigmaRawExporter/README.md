# Figma Raw Exporter

用于把 Community 文件中当前页面的全部 `COMPONENT` 导出为一个 JSON 文件，供 `tools/icons/sync-figma-export.mjs` 导入。

1. 在 Figma Desktop 中 Duplicate Community 文件到自己的 Drafts。
2. `Plugins -> Development -> Import plugin from manifest...`。
3. 选择本目录 `manifest.json`。
4. 打开 `🐱‍🚀Icon Library` 页面后运行 `ShadBlazor FreeIcon Exporter`。
5. 点击 **Export components from current page**，保存 JSON。
6. Windows 执行 `eng\sync-figma.cmd C:\path\shadblazor-freeicon-figma-export.json`。

导出保留 Figma 的组件 ID、原始名称、所属 Section、尺寸和原始 SVG。导入器会为重名组件生成稳定、唯一的公开名称。
