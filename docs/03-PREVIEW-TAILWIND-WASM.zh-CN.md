# 03 - Blazor WASM + Tailwind CSS v4 Preview

Preview 项目：

```text
preview/ShadBlazor.FreeIcon.Preview
```

技术栈：

- Microsoft.NET.Sdk.BlazorWebAssembly
- net10.0
- Microsoft.AspNetCore.Components.WebAssembly 10.0.10
- Tailwind CSS 4.3.3
- @tailwindcss/cli 4.3.3

Tailwind 源文件统一放在：

```text
configs/tailwind/app.css
```

输出到：

```text
preview/ShadBlazor.FreeIcon.Preview/wwwroot/css/app.css
```

构建 CSS：

```powershell
npm run css:build
```

监听 CSS：

```powershell
npm run css:watch
```

`tools\commands\dev.cmd` 会并行启动 Tailwind watch 与：

```powershell
dotnet watch --project preview/ShadBlazor.FreeIcon.Preview/ShadBlazor.FreeIcon.Preview.csproj --launch-profile http
```

Preview 功能：

- 响应式侧栏与顶部导航；
- 搜索、Category、Variant 和 48 条/页的目录查询；
- 尺寸、颜色、Dark Mode 与选中态；
- 图标元数据、Razor/动态名/Query 示例与复制；
- 本地构建工作流、NuGet 安装入口和许可署名页面。

Preview 只通过 ProjectReference 使用 RCL 的公开 API，不维护第二份 Icon 数据或渲染实现。
