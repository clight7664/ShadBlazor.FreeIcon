# 05 - 编辑器、打开和调试配置

## Visual Studio

打开 `ShadBlazor.FreeIcon.sln`。Solution Explorer 会看到：`src`、`preview`、`tools`、`docs`、`configs`。

第一次运行前从 VS Terminal 执行：

```powershell
tools\commands\bootstrap.cmd
```

启动项目：`ShadBlazor.FreeIcon.Preview`，profile：`http`。

## VS Code

打开：

```powershell
code ShadBlazor.FreeIcon.code-workspace
```

推荐扩展已经写入 `.vscode/extensions.json`。

常用 Task：

- `repo: doctor`
- `repo: bootstrap`
- `repo: build`
- `repo: repair`
- `repo: pack`
- `tailwind: build`
- `tailwind: watch`

调试配置：`Preview: Blazor WebAssembly`。
