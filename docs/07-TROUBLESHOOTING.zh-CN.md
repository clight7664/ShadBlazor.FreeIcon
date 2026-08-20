# 07 - 故障排查

## PowerShell：脚本未数字签名

不要执行旧 `.ps1`。运行：

```powershell
tools\commands\bootstrap.cmd
```

## NETSDK1082：Microsoft.AspNetCore.App / browser-wasm

当前仓库已经从 RCL 移除：

```xml
<FrameworkReference Include="Microsoft.AspNetCore.App" />
```

RCL 使用：

```xml
<SupportedPlatform Include="browser" />
<PackageReference Include="Microsoft.AspNetCore.Components.Web" />
```

若旧 `obj` 仍保留错误依赖图：

```powershell
tools\commands\repair.cmd
```

## CS0136：categories 重名

已经修复。`FreeIconCatalog.Load` 分别使用 `iconCategories` 与 `categoryNames`，不再在同一封闭局部范围内重复声明 `categories`。

## CS8601：可能的 null 引用赋值

已经修复。`TryGet` 现在使用：

```csharp
public static bool TryGet(
    string? name,
    [NotNullWhen(true)] out FreeIconData? icon)
```

并显式先把 `icon = null`。

## Preview 找不到图标 JSON

运行：

```powershell
tools\commands\sync-icons.cmd
```

确认存在：

```text
src/ShadBlazor.FreeIcon/Resources/lets-icons.json
src/ShadBlazor.FreeIcon/Generated/FreeIcons.Generated.cs
```

## 端口 5188 被占用

Windows：

```powershell
Get-NetTCPConnection -LocalPort 5188 | Select-Object OwningProcess
Stop-Process -Id <PID> -Force
```

或者修改 `preview/.../Properties/launchSettings.json`。
