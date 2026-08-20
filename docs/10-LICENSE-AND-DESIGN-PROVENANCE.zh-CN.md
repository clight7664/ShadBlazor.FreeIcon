# 10 - 许可、署名与设计来源

本文记录 v1.0.0 的知识产权边界和可复核的合规措施。它是工程合规记录，不替代针对特定司法辖区的法律意见。

## 1. 内容边界

| 内容 | 来源 | 许可/处理 |
| --- | --- | --- |
| Razor 组件、查询 API、生成器、验证器、预览站 | 本仓库原创实现 | MIT |
| 1,544 个 SVG 图形 | Lets Icons，Leonid Tsvetkov | CC BY 4.0 |
| 规范化元数据 | `@iconify-json/lets-icons` 1.2.2 | 固定版本与完整性哈希 |
| 预览界面 | 本仓库 Blazor + Tailwind 实现 | MIT |

上游来源和版本由 `SOURCE-LOCK.json` 固定；npm 锁文件保存依赖完整性信息。同步脚本只从该固定来源生成资源与 C# API。

## 2. 图标署名

仓库和 NuGet 包同时包含：

- `THIRD-PARTY-NOTICES.md`：作者、原始来源、分发来源和许可证链接；
- `PACKAGE-LICENSE.txt`：明确区分代码 MIT 与图形 CC BY 4.0；
- `LICENSE`：仅覆盖本仓库的软件实现；
- NuGet README 与预览站 License 页面：向最终使用者展示同一署名。

推荐在使用本图标库的产品文档、About 页面或第三方许可页面保留以下内容：

```text
Lets Icons artwork © Leonid Tsvetkov, licensed under CC BY 4.0.
https://www.figma.com/community/file/886554014393250663
```

## 3. 预览界面原创性

预览站参考过通用的文档型图标浏览器信息架构，例如侧栏导航、搜索过滤、图标网格、详情面板和代码示例。这些属于通用界面组织思路。

实际交付遵循以下边界：

- 使用 `ShadBlazor.FreeIcon` 自有名称、配色、图标标记和文案；
- 组件、Razor 结构和 Tailwind 样式均在本仓库重新实现；
- 不包含参考界面的 Logo、商标、截图、字体文件、源代码或品牌文案；
- 不声称与参考产品或 Lets Icons 作者存在合作、赞助或背书关系；
- 第三方名称只用于事实性署名与来源说明。

## 4. 发布前合规检查

每次发布执行：

1. `npm ci`，确认锁文件可复现且没有本地替换源；
2. `npm run icons:sync`，从固定依赖生成规范资源；
3. `npm run icons:verify`，检查数量、名称、SVG 安全模式与 C# 标识符唯一性；
4. `scripts\release\release.cmd <version>`，验证许可证与 notices 已进入 `.nupkg`；
5. 解包检查 nuspec 的 `license`、`projectUrl`、`repository` 和 `readme` 元数据；
6. 在 NuGet.org 提交前复核包预览中的许可证与仓库链接。

## 5. 商标和保证边界

`Lets Icons`、NuGet、GitHub 及其他第三方名称归各自权利人所有。本项目仅在必要范围内引用名称。工程检查能够降低遗漏许可、署名或混入第三方资产的风险，但不能对所有国家/地区给出绝对的“无侵权”法律保证；如用于高风险商业场景，应再由专业法律人员审阅。
