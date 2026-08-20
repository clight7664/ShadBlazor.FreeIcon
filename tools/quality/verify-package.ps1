param(
    [Parameter(Mandatory = $true)]
    [string] $PackagePath,

    [Parameter(Mandatory = $true)]
    [string] $SymbolPackagePath,

    [Parameter(Mandatory = $true)]
    [string] $ExpectedVersion
)

$ErrorActionPreference = 'Stop'

foreach ($path in @($PackagePath, $SymbolPackagePath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Package does not exist: $path"
    }
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $PackagePath))
try {
    $entryNames = @($archive.Entries | ForEach-Object FullName)
    $nuspecEntry = $archive.Entries | Where-Object FullName -Like '*.nuspec' | Select-Object -First 1
    if ($null -eq $nuspecEntry) {
        throw 'NuGet package has no nuspec.'
    }

    $reader = [System.IO.StreamReader]::new($nuspecEntry.Open())
    try {
        [xml] $nuspec = $reader.ReadToEnd()
    }
    finally {
        $reader.Dispose()
    }

    $metadata = $nuspec.package.metadata
    if ($metadata.id -ne 'ShadBlazor.FreeIcon') {
        throw "Unexpected package id '$($metadata.id)'."
    }
    if ($metadata.version -ne $ExpectedVersion) {
        throw "Package version '$($metadata.version)' does not match '$ExpectedVersion'."
    }
    if ($metadata.readme -ne 'README.md' -or $metadata.license.'#text' -ne 'PACKAGE-LICENSE.txt') {
        throw 'NuGet package readme or license metadata is invalid.'
    }
    if ([string]::IsNullOrWhiteSpace($metadata.description) -or
        [string]::IsNullOrWhiteSpace($metadata.releaseNotes) -or
        [string]::IsNullOrWhiteSpace($metadata.projectUrl)) {
        throw 'NuGet package description, release notes and project URL are required.'
    }
    if ($metadata.projectUrl -ne 'https://github.com/clight7664/ShadBlazor.FreeIcon') {
        throw "Unexpected project URL '$($metadata.projectUrl)'."
    }
    if ($metadata.repository.type -ne 'git' -or
        $metadata.repository.url -ne 'https://github.com/clight7664/ShadBlazor.FreeIcon.git') {
        throw 'NuGet package repository metadata is missing or invalid.'
    }
    if ([string] $metadata.authors -notmatch 'clight7664') {
        throw "NuGet package authors '$($metadata.authors)' do not identify the maintainer."
    }

    $expectedDependencies = @{
        'net8.0' = '8.0.0'
        'net9.0' = '9.0.0'
        'net10.0' = '10.0.0'
    }
    foreach ($group in @($metadata.dependencies.group)) {
        $framework = [string] $group.targetFramework
        if (-not $expectedDependencies.ContainsKey($framework)) {
            continue
        }
        $componentsDependency = @($group.dependency) |
            Where-Object id -EQ 'Microsoft.AspNetCore.Components.Web' |
            Select-Object -First 1
        if ($null -eq $componentsDependency -or
            $componentsDependency.version -ne $expectedDependencies[$framework]) {
            throw "Unexpected Microsoft.AspNetCore.Components.Web dependency for $framework."
        }
        $expectedDependencies.Remove($framework)
    }
    if ($expectedDependencies.Count -ne 0) {
        throw "Missing dependency groups: $($expectedDependencies.Keys -join ', ')."
    }

    $requiredEntries = @(
        'README.md',
        'LICENSE',
        'PACKAGE-LICENSE.txt',
        'THIRD-PARTY-NOTICES.md',
        'lib/net8.0/ShadBlazor.FreeIcon.dll',
        'lib/net9.0/ShadBlazor.FreeIcon.dll',
        'lib/net10.0/ShadBlazor.FreeIcon.dll'
    )
    foreach ($entry in $requiredEntries) {
        if ($entryNames -notcontains $entry) {
            throw "NuGet package is missing '$entry'."
        }
    }

    $noticeEntry = $archive.Entries | Where-Object FullName -EQ 'THIRD-PARTY-NOTICES.md' | Select-Object -First 1
    $noticeReader = [System.IO.StreamReader]::new($noticeEntry.Open())
    try {
        $notice = $noticeReader.ReadToEnd()
    }
    finally {
        $noticeReader.Dispose()
    }
    if ($notice -notmatch 'Leonid Tsvetkov' -or $notice -notmatch 'CC BY 4\.0') {
        throw 'Packaged third-party notice is missing the Lets Icons author or license attribution.'
    }
}
finally {
    $archive.Dispose()
}

$symbolArchive = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $SymbolPackagePath))
try {
    $pdbs = @($symbolArchive.Entries | Where-Object FullName -Like '*.pdb')
    if ($pdbs.Count -lt 3) {
        throw "Symbol package contains $($pdbs.Count) PDB files; expected at least 3."
    }
}
finally {
    $symbolArchive.Dispose()
}

Write-Host "Verified NuGet package ShadBlazor.FreeIcon $ExpectedVersion."
