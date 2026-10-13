# Run-All.ps1 - run every encoding demo in order, ASCII summary.
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File Run-All.ps1 [-WorkDir <dir>]
#   pwsh -NoProfile -File Run-All.ps1 [-WorkDir <dir>]
[CmdletBinding()]
param(
    [string]$WorkDir = '',
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Output 'Usage: Run-All.ps1 [-WorkDir <dir>] [-Help]'
}

function Main {
    if ([string]::IsNullOrWhiteSpace($WorkDir)) {
        $WorkDir = Join-Path ([System.IO.Path]::GetTempPath()) 'ps-enc-demo'
    }
    $scripts = @(
        'Show-EncodingDefaults.ps1',
        'Test-ReadLayer.ps1',
        'Test-OutputLayer.ps1',
        'Test-NativePipe.ps1',
        'Test-RedirectDefaults.ps1'
    )
    $failed = 0
    foreach ($name in $scripts) {
        $p = Join-Path $PSScriptRoot $name
        Write-Output ('==== ' + $name + ' ====')
        if ($name -eq 'Show-EncodingDefaults.ps1' -or $name -eq 'Test-OutputLayer.ps1' -or $name -eq 'Test-NativePipe.ps1') {
            & $p
        } else {
            & $p -WorkDir $WorkDir
        }
        $code = $LASTEXITCODE
        Write-Output ('exit=' + $code)
        if ($code -ne 0) { $failed++ }
    }
    Write-Output ('summary.failed=' + $failed + '/' + $scripts.Count)
    if ($failed -gt 0) { exit 1 }
    exit 0
}

if ($Help) { Show-Usage; exit 0 }
try { Main } catch { Write-Error $_; exit 1 }
