# 02 - 维护者完整实施文档

完整的端到端架构、构建、包验证、NuGet 手工/CLI/CI 发布、线上验收和回滚流程见：

```text
docs/09-ICON-ARCHITECTURE-AND-NUGET-RELEASE.zh-CN.md
```

## 架构

运行时只包含：

```text
FreeIcon.razor
FreeIconData
FreeIconRegistry
FreeIcons.Generated.cs
Embedded Resource: lets-icons.json
SvgIdRewriter
```

构建时工具：

```text
@iconify-json/lets-icons@1.2.2
        ↓
tools/icons/sync-icons.mjs
        ↓
Resources/lets-icons.json      1544 图标
Generated/FreeIcons.Generated.cs
        ↓
Razor Class Library
```

## 为什么不用 1544 个 `.razor`

一个 renderer + 数据目录可以减少 Razor 编译单元数量，同时保留 IntelliSense 强类型属性。静态场景用 `FreeIcons.Xxx`，动态场景用 registry。

## 同步图标

```powershell
tools\commands\sync-icons.cmd
```

同步器会强制验证：

- npm package 必须是 `1.2.2`
- `icons` 数量必须等于 `SOURCE-LOCK.json` 中的 `1544`
- C# property name 必须唯一
- SVG 不允许 script / foreignObject / 外部资源 / event handler / javascript URL

## 修改上游版本

不要只改 `package.json`。升级时同时审查并修改：

```text
package.json
SOURCE-LOCK.json
THIRD-PARTY-NOTICES.md（若许可/作者变化）
```

然后运行：

```powershell
tools\commands\bootstrap.cmd
```

## 构建

```powershell
tools\commands\build.cmd
```

它会重新验证项目模型、SVG、安全性、Tailwind、三个 TFM，以及编译后的 catalog。

## 打包

```powershell
tools\commands\pack.cmd -p:PackageVersion=1.0.0
```

输出：

```text
release/packages/ShadBlazor.FreeIcon.1.0.0.nupkg
release/packages/ShadBlazor.FreeIcon.1.0.0.snupkg
```

## 必须提交哪些生成物

推荐把以下两个文件提交进 Git：

```text
src/ShadBlazor.FreeIcon/Resources/lets-icons.json
src/ShadBlazor.FreeIcon/Generated/FreeIcons.Generated.cs
```

这样消费者和 CI 可审计实际发出的图标快照，并且在已 restore 的环境可离线构建。
