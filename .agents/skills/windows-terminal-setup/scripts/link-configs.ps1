[CmdletBinding()]
param(
    [switch]$ValidateOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Convert-ToCanonicalPath {
    param([Parameter(Mandatory)][string]$Path)

    $providerPrefix = "Microsoft.PowerShell.Core\FileSystem::"
    $normalized = $Path.Replace("/", "\")
    if ($normalized.StartsWith($providerPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        $normalized = $normalized.Substring($providerPrefix.Length)
    }
    if ($normalized.StartsWith("UNC\", [StringComparison]::OrdinalIgnoreCase)) {
        $normalized = "\\" + $normalized.Substring(4)
    }
    if ($normalized.StartsWith("\\wsl.localhost\", [StringComparison]::OrdinalIgnoreCase)) {
        $normalized = "\\wsl$\" + $normalized.Substring("\\wsl.localhost\".Length)
    }

    return [System.IO.Path]::GetFullPath($normalized).TrimEnd("\")
}

function Get-LinkTarget {
    param([Parameter(Mandatory)][System.IO.FileSystemInfo]$Item)

    if ($Item.LinkType -ne "SymbolicLink") {
        return $null
    }

    return Convert-ToCanonicalPath ([string]$Item.Target)
}

function Ensure-ConfigLink {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "$Name source config does not exist: $Source"
    }

    $expectedTarget = Convert-ToCanonicalPath $Source
    $existingItem = Get-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
    if ($null -ne $existingItem) {
        $actualTarget = Get-LinkTarget $existingItem
        if ($null -eq $actualTarget) {
            throw "Refusing to replace non-symlink at $Destination"
        }
        if (-not $actualTarget.Equals($expectedTarget, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to replace $Destination; it points to $actualTarget instead of $expectedTarget"
        }

        Write-Output "[ok] ${Name}: $Destination -> $expectedTarget"
        return
    }

    if ($ValidateOnly) {
        throw "$Name link is missing: $Destination"
    }

    $parent = Split-Path -Parent $Destination
    $null = New-Item -ItemType Directory -Path $parent -Force
    try {
        $null = New-Item -ItemType SymbolicLink -Path $Destination -Target $expectedTarget
    }
    catch {
        throw "Failed to create $Name link. Enable Windows Developer Mode or run elevated. $($_.Exception.Message)"
    }

    $createdItem = Get-Item -LiteralPath $Destination -Force
    $createdTarget = Get-LinkTarget $createdItem
    if ($null -eq $createdTarget -or -not $createdTarget.Equals($expectedTarget, [StringComparison]::OrdinalIgnoreCase)) {
        throw "$Name link validation failed: $Destination"
    }

    Write-Output "[created] ${Name}: $Destination -> $expectedTarget"
}

$repoRoot = Convert-ToCanonicalPath (
    (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..\..")).ProviderPath
)

$links = @(
    @{
        Name = "WezTerm"
        Source = Join-Path $repoRoot "wezterm\.config\wezterm\wezterm.lua"
        Destination = Join-Path $env:USERPROFILE ".config\wezterm\wezterm.lua"
    },
    @{
        Name = "Alacritty"
        Source = Join-Path $repoRoot "alacritty\.config\alacritty\alacritty.toml"
        Destination = Join-Path $env:APPDATA "alacritty\alacritty.toml"
    }
)

foreach ($link in $links) {
    Ensure-ConfigLink @link
}
