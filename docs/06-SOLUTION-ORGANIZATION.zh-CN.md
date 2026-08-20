# 06 - 解决方案组织

解决方案把可发布代码、可运行示例、生成/验证工具和文档明确分层。业务项目只位于 `src / preview`，编译型验证器位于 `tools`。

```text
ShadBlazor.FreeIcon.sln
├─ src
│  └─ ShadBlazor.FreeIcon
├─ preview
│  └─ ShadBlazor.FreeIcon.Preview
├─ tools
│  ├─ ShadBlazor.FreeIcon.Verifier
│  ├─ icons / quality / pages
│  ├─ commands
│  └─ FigmaRawExporter
├─ docs
│  └─ *.md
└─ configs
   └─ Tailwind、MSBuild、NuGet、VS Code、GitHub Actions 等 Solution Items
```

物理目录：

```text
src/        NuGet RCL；只放公共组件、模型、内部运行时代码与嵌入资源
preview/    Blazor WASM 示例站；不被 NuGet 项目引用
configs/    Tailwind 输入和编辑器说明
tools/      命令入口、生成器、验证器、Pages 处理和可选 Figma 工具
docs/       用户、维护、架构、发布和许可文档
eng/        指向 tools/commands 的短兼容入口，不保存第二份实现
scripts/    面向 build/pack/release 等具体任务的薄包装
.github/    CI、GitHub Pages 和 NuGet Release 工作流
.vscode/    VS Code 配置
release/    发布说明和本地产物目录；release/packages 不进入 Git
```

`Directory.Build.props`、`Directory.Packages.props`、`global.json` 等必须位于根目录，才能让 MSBuild/NuGet 自动发现；它们在 `.sln` 里归入 `configs` Solution Folder。

## 项目依赖方向

```text
Preview ────────────────┐
                       ├──> ShadBlazor.FreeIcon
Compiled Verifier ─────┘

ShadBlazor.FreeIcon 不能反向引用 Preview、Verifier 或生成脚本。
```

`Generated/FreeIcons.Generated.cs` 和 `Resources/lets-icons.json` 是确定性生成结果，必须提交以保证 NuGet 项目在没有 Node.js 的消费者环境中也能构建；`bin/obj`、生成 CSS 和本地包不提交。

## 预览项目内部边界

```text
Layout/                 应用外壳、侧栏和顶栏
Pages/                  路由页面
Components/IconBrowser 图标工作台专用组件
Components/             跨页面小组件
wwwroot/                静态宿主；css/app.css 由 Tailwind 生成
```

Preview 通过项目引用消费 RCL 的真实公开 API，不复制图标模型或 SVG 渲染逻辑，因此预览构建同时也是对 NuGet 消费路径的一次集成检查。

## 临时文件规则

- `.vs/`、`bin/`、`obj/`、`artifacts/`、`node_modules/`：本地缓存，已忽略；
- `release/packages/`：每次发布重新生成，已忽略；
- `preview/**/wwwroot/css/app.css`：由 `npm run css:build` 生成，已忽略；
- 根目录不得保存 `*.zip.tmp`、临时解包目录或带密钥的配置文件。
