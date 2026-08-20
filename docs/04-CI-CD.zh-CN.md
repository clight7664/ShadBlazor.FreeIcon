# 04 - CI/CD

## CI

`.github/workflows/ci.yml` 执行：

1. setup .NET 8/9/10
2. setup Node
3. `npm install`
4. 项目模型检查
5. 生成 1544 图标
6. SVG/标识符校验
7. Tailwind build
8. `dotnet restore`
9. `dotnet build -c Release`
10. 编译后 verifier
11. `dotnet pack`
12. 上传 NuGet artifact

## GitHub Pages

`.github/workflows/pages.yml` 发布 Blazor WASM Preview，并自动把 `<base href>` 改为仓库子路径，同时生成 `404.html` 和 `.nojekyll`。

## NuGet Release

打 tag：

```bash
git tag v1.0.0
git push origin v1.0.0
```

`release.yml` 会构建并验证 NuGet 包，然后执行 `dotnet nuget push`。Release workflow
强制要求仓库 Secret `NUGET_API_KEY`；缺少 Secret 时 job 会失败，避免出现“流水线成功但没有实际发布”的假阳性。

完整发布和线上验收步骤见 `docs/09-ICON-ARCHITECTURE-AND-NUGET-RELEASE.zh-CN.md`。
