# 09 - Icon 架构、构建验证与 NuGet 发布完整流程手册

本文是 `ShadBlazor.FreeIcon` 的维护者操作手册，覆盖从环境准备、Icon
数据同步、架构验证、构建打包，到 NuGet.org 手工或自动发布、线上验收和故障处理的完整流程。

当前稳定基线：

| 项目 | 当前值 |
| --- | --- |
| Package ID | `ShadBlazor.FreeIcon` |
| 稳定版本 | `1.0.0` |
| Icon 来源 | `@iconify-json/lets-icons` |
| 上游版本 | `1.2.2` |
| Canonical Icon 数量 | `1544` |
| 分类数量 | `44` |
| 实际变体数量 | `5` |
| 目标框架 | `net8.0;net9.0;net10.0` |
| NuGet 输出目录 | `release/packages` |
| Git 仓库 | `https://github.com/clight7664/ShadBlazor.FreeIcon` |
| 源码许可 | MIT |
| Icon Artwork 许可 | CC BY 4.0 |

> 维护原则：同一个 NuGet 版本不可覆盖。任何包内容或元数据变化都必须使用新版本号。

## 1. 仓库职责与目录结构

```text
src/ShadBlazor.FreeIcon/                 核心 Razor Class Library
  Components/FreeIcon.razor             SVG 渲染组件
  Icons/FreeIconData.cs                 不可变 Icon 元数据
  Icons/FreeIconRegistry.cs             动态查询入口
  Icons/FreeIconQuery.cs                组合查询条件
  Icons/FreeIconQueryResult.cs          分页查询结果
  Icons/FreeIconVariant.cs              Icon 变体
  Generated/FreeIcons.Generated.cs      1544 个强类型属性
  Internal/FreeIconCatalog.cs           延迟目录、分类/变体索引、搜索排序
  Internal/SvgIdRewriter.cs             每实例 SVG ID 隔离
  Resources/lets-icons.json             嵌入式规范化 Iconify 数据

preview/ShadBlazor.FreeIcon.Preview/     Blazor WebAssembly 文档预览
tools/icons/                             Icon 同步与安全验证
tools/quality/                           仓库和 NuGet 包验证
tools/ShadBlazor.FreeIcon.Verifier/      编译后目录/API 验证器
tools/commands/                          Windows/POSIX 主命令
scripts/release/                         版本发布入口
release/packages/                        经过验证的 NuGet 制品
docs/                                    用户、维护、CI/CD 与发布文档
```

### 1.1 Git 分阶段交付

远程 `main` 是可构建主线。不要把结构整理、Preview 重构、文档和最终包哈希压成一个不可审阅的提交。推荐顺序：

```powershell
git status --short
npm run repo:verify
git add <本阶段文件>
git commit -m "<type>: <本阶段目标>"
git push origin main
```

v1.0.0 实际阶段：

1. `chore`：建立解决方案、生成链、验证器和远程基线；
2. `feat(preview)`：提交响应式图标工作台；
3. `docs`：提交 README、目录边界、许可与设计来源；
4. `release`：提交最终验证状态、哈希与版本记录；
5. 确认远程 CI 成功后创建 `v1.0.0` tag；
6. 使用同一 tag/commit 产生的包提交 NuGet.org。

每次提交前执行 `git diff --check`，并确认 `git status` 不包含 `.vs`、`bin/obj`、`node_modules`、`release/packages`、生成 CSS、临时压缩文件或密钥。

## 2. Icon 运行时架构

```text
lets-icons.json（EmbeddedResource）
              │
              ▼
FreeIconCatalog（Lazy、线程安全、一次加载）
  ├─ ByName：大小写不敏感动态查询
  ├─ ByCategory：分类预索引
  ├─ ByVariant：变体预索引
  └─ Search/Query：排序、过滤、分页
              │
      ┌───────┴────────┐
      ▼                ▼
FreeIcons          FreeIconRegistry
强类型 API         动态/搜索 API
      └───────┬────────┘
              ▼
       FreeIconData（不可变）
              ▼
       FreeIcon.razor
              ▼
SVG currentColor + a11y + 每实例 ID 隔离
```

设计要点：

1. 不生成 1544 个 Razor 组件，避免大量 Razor 编译单元。
2. 强类型 API 和动态 API 返回同一份不可变 `FreeIconData` 实例。
3. 目录首次访问时加载；后续名称、分类和变体查询复用索引。
4. 原始 SVG Body 仅在程序集内部可见，组件只渲染经过固定生成流程验证的嵌入资源。
5. SVG 内部 `id`、`url(...)`、`href`、`xlink:href` 按组件实例重写，避免多个图标同页冲突。
6. 组件库不依赖 JavaScript；Preview 的剪贴板和主题功能不属于运行时 Icon 包依赖。

## 3. 面向消费者的 API

安装：

```powershell
dotnet add package ShadBlazor.FreeIcon --version 1.0.0
```

在 `_Imports.razor` 中导入：

```razor
@using ShadBlazor.FreeIcon
```

强类型使用：

```razor
<FreeIcon Icon="@FreeIcons.Search" Size="24px" />
```

动态名称使用：

```razor
<FreeIcon Name="search" Size="1.5rem" Color="currentColor" />
```

可访问性：

```razor
@* 无名称时自动作为装饰图标 *@
<FreeIcon Icon="@FreeIcons.Search" />

@* 业务图标使用 Title 或 AriaLabel *@
<FreeIcon Icon="@FreeIcons.Search" AriaLabel="搜索" />
<FreeIcon Icon="@FreeIcons.Info" Title="信息" />
```

目录查询：

```csharp
var icon = FreeIconRegistry.Get("search");

if (FreeIconRegistry.TryGet(input, out var selected))
{
    // selected 为非空、不可变实例
}

var result = FreeIconRegistry.Query(new FreeIconQuery
{
    Text = "arrow",
    Category = "Arrow",
    Variant = FreeIconVariant.Light,
    Skip = 0,
    Take = 48
});

Console.WriteLine($"{result.Items.Count}/{result.TotalCount}");
```

兼容辅助 API：

```csharp
FreeIconRegistry.All
FreeIconRegistry.Names
FreeIconRegistry.Categories
FreeIconRegistry.Variants
FreeIconRegistry.Search("arrow", 100)
FreeIconRegistry.InCategory("Media")
FreeIconRegistry.InVariant(FreeIconVariant.Duotone)
```

## 4. 环境准备

必须安装：

- .NET SDK 10.x；本仓库 `global.json` 基准为 `10.0.400`。
- .NET 8、9、10 targeting packs。
- Node.js 20+ 与 npm。
- Git（CI、tag 和 Repository Metadata 使用）。

检查环境：

```powershell
tools\commands\doctor.cmd
```

第一次初始化：

```powershell
tools\commands\bootstrap.cmd
```

Bootstrap 负责：

1. 安装锁定的 npm 依赖。
2. 从锁定的 Lets Icons 数据生成 1544 个图标。
3. 验证 JSON、SVG 安全规则和 C# 标识符唯一性。
4. 构建 Tailwind CSS。
5. restore 和 Release build 全部项目。
6. 运行编译后的 Icon verifier。

成功标志：

```text
Bootstrap succeeded. The repository is ready to run.
```

## 5. 日常开发流程

启动 Preview：

```powershell
tools\commands\dev.cmd
```

默认地址：

```text
http://localhost:5188
```

主要路由：

- `/`：项目介绍与 Icon Browser。
- `/icons`：完整 Icon Browser。
- `/usage`：使用说明。
- `/license`：许可和归属说明。

提交代码前执行：

```powershell
npm run verify
tools\commands\build.cmd
```

`build.cmd` 不是单纯的 `dotnet build`，它还会验证仓库模型、Icon 资源、Tailwind、
三个目标框架和编译后的目录契约。

## 6. 同步或升级 Icon 数据

同步当前锁定版本：

```powershell
tools\commands\sync-icons.cmd
```

生成链路：

```text
package.json + package-lock.json + SOURCE-LOCK.json
                           │
                           ▼
              tools/icons/sync-icons.mjs
                  ├─ Resources/lets-icons.json
                  └─ Generated/FreeIcons.Generated.cs
```

同步器必须保证：

- 包版本与 `SOURCE-LOCK.json` 一致。
- Canonical 数量等于 1544。
- C# 属性名无冲突。
- SVG 不包含 `script`、`foreignObject`、外部 URL、事件属性或 JavaScript URL。
- 生成结果可重复。

升级上游版本时必须一起审查：

```text
package.json
package-lock.json
SOURCE-LOCK.json
THIRD-PARTY-NOTICES.md
src/ShadBlazor.FreeIcon/Resources/lets-icons.json
src/ShadBlazor.FreeIcon/Generated/FreeIcons.Generated.cs
```

不要只改 npm 版本后直接发布。

## 7. 版本发布前检查清单

发布前逐项确认：

- [ ] `Version` 和目标发布版本一致。
- [ ] `CHANGELOG.md` 已包含该版本。
- [ ] README 安装命令使用该版本。
- [ ] `SOURCE-LOCK.json` 与真实数据一致。
- [ ] Icon 数量、分类和变体验证通过。
- [ ] .NET 8/9/10 构建为 0 警告、0 错误。
- [ ] Preview `/icons` 可启动并可搜索、过滤、分页。
- [ ] 源码 MIT 与 Artwork CC BY 4.0 声明均已打包。
- [ ] `PackageProjectUrl` 为 `https://github.com/clight7664/ShadBlazor.FreeIcon`。
- [ ] `RepositoryUrl` 为 `https://github.com/clight7664/ShadBlazor.FreeIcon.git`。
- [ ] `.nupkg` 与 `.snupkg` 均已生成。
- [ ] 独立消费者能从本地包源安装并编译。
- [ ] NuGet.org 中不存在同 Package ID + Version。

版本相关文件：

```text
src/ShadBlazor.FreeIcon/ShadBlazor.FreeIcon.csproj
package.json
package-lock.json
CHANGELOG.md
README.md
docs/（示例版本）
```

## 8. 构建和验证正式包

推荐使用完整发布入口：

```powershell
scripts\release\release.cmd 1.0.0
```

流程：

```text
repo verify
  -> icon verify
  -> Tailwind build
  -> restore
  -> Release build
  -> compiled verifier
  -> dotnet pack
  -> verify-package.ps1
```

输出：

```text
release/packages/ShadBlazor.FreeIcon.1.0.0.nupkg
release/packages/ShadBlazor.FreeIcon.1.0.0.snupkg
```

包验证器检查：

- Package ID 和版本。
- Description、Release Notes、Project URL、README 和 License metadata。
- `net8.0`、`net9.0`、`net10.0` 依赖组。
- 三个目标框架的 DLL。
- README、MIT、组合许可和第三方声明。
- Symbol Package 至少包含三个 PDB。

当前 v1.0.0 最终制品 SHA-256 在每次最终打包后写入本节；不得沿用旧包哈希：

```text
4820A6FBF69F8DDBD24B9F6641B5D7C90F9482A6FC45C0D5EBB480585B0FE032  ShadBlazor.FreeIcon.1.0.0.nupkg
A3E6D4D24E916F8CC3BAC383FE68B605B193C799EEC0C400ABEE1570878C057F  ShadBlazor.FreeIcon.1.0.0.snupkg
```

重新打包后哈希必然变化，必须重新计算并更新发布记录：

```powershell
Get-FileHash -Algorithm SHA256 release\packages\ShadBlazor.FreeIcon.1.0.0.nupkg
Get-FileHash -Algorithm SHA256 release\packages\ShadBlazor.FreeIcon.1.0.0.snupkg
```

## 9. 独立消费者冒烟测试

不要只验证仓库内部 ProjectReference。创建一个仓库外的干净 Razor 项目，从本地包目录安装：

```powershell
dotnet new razorclasslib -n Consumer -f net8.0
cd Consumer
dotnet add package ShadBlazor.FreeIcon --version 1.0.0 `
  --source E:\ShadBlazor.FreeIcon\release\packages
```

在组件中同时编译：

```razor
<FreeIcon Icon="@FreeIcons.Search" />
<FreeIcon Name="home" />
```

并调用 `FreeIconRegistry.Query(...)`。最终必须：

```text
0 warnings
0 errors
```

当前包把 `Microsoft.AspNetCore.Components.Web` 的最低依赖设为
`8.0.0 / 9.0.0 / 10.0.0`，消费者自行选择各大版本的安全补丁，不应被库强制到某个补丁号。

## 10. NuGet.org 凭据准备

推荐两种方式：

1. 浏览器人工登录，用于首次包 ID 创建和手工核验。
2. 作用域受限的 API Key，用于 CLI 或 CI。

API Key 最小权限建议：

- 只允许 `Push new packages and package versions`。
- Package Pattern 限制为 `ShadBlazor.FreeIcon`。
- 设置合理过期时间。
- 只存放于用户环境变量或 GitHub Actions Secret。

不要：

- 把 API Key 写进 `.cmd`、`.ps1`、`nuget.config` 并提交。
- 在聊天、Issue、日志或截图中公开 Key。
- 给无关 Package ID 使用通配权限。

## 11. 浏览器手工发布流程

1. 登录 `https://www.nuget.org/`。
2. 打开 `Upload`：`https://www.nuget.org/packages/manage/upload`。
3. 选择 `ShadBlazor.FreeIcon.1.0.0.nupkg`。
4. 等待 NuGet.org 解析完成。
5. 核对：
   - Package ID：`ShadBlazor.FreeIcon`
   - Version：`1.0.0`
   - Owner：预期维护者账号
   - Target Framework：net8.0 / net9.0 / net10.0
   - Dependencies：对应大版本 `.0` 最低依赖
   - License、README、Release Notes 和 Tags
   - Package Visibility 是否勾选
   - Project URL 与 Repository URL
6. 点击 `Submit` 公开发布主包。
7. 等待 NuGet.org 完成主包验证和索引。
8. 网页 Upload 流程只用于主 `.nupkg`。`.snupkg` 按 NuGet 官方符号包流程通过 NuGet V3 API 发布；不要把“在网页再次上传符号包”写成必需步骤。

注意：选择文件只是进入 Verify 阶段；`Submit` 才会产生正式公开版本。官方流程：

- `https://learn.microsoft.com/nuget/nuget-org/publish-a-package`
- `https://learn.microsoft.com/nuget/create-packages/symbol-packages-snupkg`

## 12. CLI 发布流程

先设置当前 PowerShell 会话的环境变量：

```powershell
$env:NUGET_API_KEY = '<scoped-api-key>'
```

发布：

```powershell
scripts\release\push-nuget.cmd 1.0.0
```

底层命令：

```powershell
dotnet nuget push `
  release\packages\ShadBlazor.FreeIcon.1.0.0.nupkg `
  --api-key $env:NUGET_API_KEY `
  --source https://api.nuget.org/v3/index.json `
  --skip-duplicate
```

发布符号包需要 NuGet V3 源。执行后必须查看输出，确认主包与 `.snupkg` 均已推送；如果脚本/客户端没有自动推送符号包，则显式执行：

```powershell
dotnet nuget push `
  release\packages\ShadBlazor.FreeIcon.1.0.0.snupkg `
  --api-key $env:NUGET_API_KEY `
  --source https://api.nuget.org/v3/index.json `
  --skip-duplicate
```

## 13. GitHub Actions 自动发布

仓库 Secret：

```text
NUGET_API_KEY
```

Release workflow：

```text
.github/workflows/release.yml
```

Tag 发布：

```bash
git tag v1.0.0
git push origin v1.0.0
```

流水线会：

1. 安装 .NET 8/9/10 和 Node。
2. 同步、验证 1544 个 Icon。
3. 构建 CSS、Solution 和编译后 verifier。
4. Pack 指定版本。
5. 验证包内容。
6. 上传 workflow artifact。
7. 强制要求 `NUGET_API_KEY`；缺少 Secret 时 Release job 失败，不会伪装成发布成功。
8. 推送 NuGet 主包和符号包。

## 14. 发布后在线验收

NuGet 页面：

```text
https://www.nuget.org/packages/ShadBlazor.FreeIcon/1.0.0
```

Flat Container 版本索引：

```text
https://api.nuget.org/v3-flatcontainer/shadblazor.freeicon/index.json
```

线上验收清单：

- [ ] 包页面显示 Version `1.0.0`。
- [ ] Owner、License、README、依赖组和 Tags 正确。
- [ ] 包处于 Listed 状态。
- [ ] Flat Container 索引包含 `1.0.0`。
- [ ] 新目录中只使用 NuGet.org 能 restore 包。
- [ ] 强类型、动态名称和 Query API 能编译。
- [ ] Symbol Package 状态正常。

索引通常不是瞬时完成。提交成功后可以间隔检查，但不要重复上传相同版本。

## 15. 回滚、撤回和紧急修复

NuGet.org 不允许覆盖或重新上传已存在的 `Package ID + Version`。

如果发现问题：

1. 不要尝试覆盖 `1.0.0`。
2. 评估是否需要在 NuGet.org 把问题版本 Unlist 或 Deprecate。
3. 修改代码、补回归验证。
4. 发布 `1.0.1` 或其他符合 SemVer 的后续版本。
5. 若怀疑 Key 泄漏，立即在 NuGet.org 撤销旧 Key，并更新 GitHub Secret。

Unlist/Deprecate 会影响外部消费者，执行前必须由维护者明确确认。

## 16. 常见故障

### `NETSDK1082` / browser-wasm

不要给 RCL 添加：

```xml
<FrameworkReference Include="Microsoft.AspNetCore.App" />
```

本项目使用 `Microsoft.AspNetCore.Components.Web` 和 `SupportedPlatform browser`。

修复：

```powershell
tools\commands\repair.cmd
```

### `NU1605` 包降级

检查 nuspec 中的 `Microsoft.AspNetCore.Components.Web` 最低依赖。Icon 库最低应为
各目标大版本 `.0`，不要把本地构建使用的补丁版本变成消费者最低要求。

### Icon 数量不是 1544

确认：

```text
package.json
package-lock.json
SOURCE-LOCK.json
node_modules/@iconify-json/lets-icons
```

然后运行：

```powershell
npm install --no-audit --no-fund --ignore-scripts
tools\commands\sync-icons.cmd
npm run icons:verify
```

### 包已经存在 / 409 Conflict

同版本不可覆盖。若线上内容正确，`--skip-duplicate` 可让自动流程幂等；若内容不同，必须升版本。

### 401 / 403

- 确认 API Key 未过期。
- 确认 Package Pattern 允许 `ShadBlazor.FreeIcon`。
- 确认账号是 Package Owner。
- 首次创建包 ID 时确认当前账号有发布权限。

### 包已提交但搜索不到

先检查 Flat Container 和包详情直链。NuGet 搜索索引存在延迟，不要立即重复发布。

### Symbol Package 未出现

确认 `.snupkg` 与 `.nupkg` 的 Package ID、Version 一致，并使用 CLI 自动符号推送或在 Upload 页面单独上传 `.snupkg`。

## 17. 每次发布的记录模板

```markdown
## ShadBlazor.FreeIcon x.y.z

- Build commit/tag:
- Package ID:
- Version:
- Main package SHA-256:
- Symbol package SHA-256:
- Icon source/version/count:
- Build result:
- Compiled verifier result:
- Independent consumer result:
- NuGet owner:
- NuGet package URL:
- Flat-container verification time:
- Symbol status:
- Known limitations:
```

发布完成后，把实际 URL、时间和状态写入 `VALIDATION.md` 或独立 Release Record，
不要仅凭 CLI 返回码声称发布成功。
