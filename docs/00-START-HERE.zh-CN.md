# 00 - 从这里开始

## 1. 先覆盖旧仓库还是新建目录？

推荐把本代码包解压为一个全新目录，例如：

```text
E:\ShadBlazor.FreeIcon
```

不要把旧版本的 `bin/obj` 一起复制过来。若已经覆盖旧目录，先运行：

```powershell
tools\commands\clean.cmd
```

## 2. 环境

需要：

- .NET SDK 10.x（仓库 `global.json` 基准为 10.0.400，允许向更新 feature band roll-forward）
- Node.js 20+
- npm
- Git（发布/CI 推荐）

检查：

```powershell
tools\commands\doctor.cmd
```

## 3. 第一次初始化

```powershell
tools\commands\bootstrap.cmd
```

不要运行 `.ps1`。本仓库 Windows 主入口全部是 `.cmd`，因此不会受到 PowerShell `ExecutionPolicy` 的未签名脚本限制。

Bootstrap 必须最终打印：

```text
Bootstrap succeeded. The repository is ready to run.
```

## 4. 启动 Preview

```powershell
tools\commands\dev.cmd
```

浏览器：`http://localhost:5188`

## 5. Visual Studio

打开：

```text
ShadBlazor.FreeIcon.sln
```

把 `ShadBlazor.FreeIcon.Preview` 设为启动项目，选择 `http` profile。

## 6. 如果之前出现 NETSDK1082

运行：

```powershell
tools\commands\repair.cmd
```

当前 RCL 不再引用 `Microsoft.AspNetCore.App`，而是使用 `Microsoft.AspNetCore.Components.Web` + `SupportedPlatform browser`。`repair.cmd` 会清掉所有项目的 `bin/obj` 后重新 restore/build。

## 7. 架构、构建和发布

完整维护与 NuGet 发布流程见：

```text
docs/09-ICON-ARCHITECTURE-AND-NUGET-RELEASE.zh-CN.md
```
