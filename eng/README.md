# eng scripts

Windows users should use the `.cmd` entry points. They do **not** depend on PowerShell execution policy.

- `bootstrap.cmd`: npm install → all 1544 icons → Tailwind CSS → dotnet restore
- `dev.cmd`: Tailwind watch + `dotnet watch` preview
- `build.cmd`: icon verification → CSS → Release build → runtime verifier
- `pack.cmd`: build + NuGet package
- `sync-icons.cmd`: regenerate only the icon catalog/API
- `clean.cmd`: clean local outputs

macOS/Linux equivalents use `.sh`.
