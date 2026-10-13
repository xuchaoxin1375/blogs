# Test-RedirectDefaults.ps1 - redirection/file-write defaults per host version.
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File Test-RedirectDefaults.ps1 [-WorkDir <dir>]
#   pwsh -NoProfile -File Test-RedirectDefaults.ps1 [-WorkDir <dir>]
# ASCII-only source. Classifies on-disk bytes by BOM/strict-UTF-8, not glyphs.
[CmdletBinding()]
param(
    [string]$WorkDir = '',
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Output 'Usage: Test-RedirectDefaults.ps1 [-WorkDir <dir>] [-Help]'
    Write-Output 'Writes the same String via >, Out-File, Set-Content, explicit'
    Write-Output 'UTF-8 and .NET NoBOM, then classifies head bytes.'
}

function ConvertTo-HexLine {
    param([byte[]]$Bytes, [int]$Take = 8)
    if ($null -eq $Bytes -or $Bytes.Length -eq 0) { return '(empty)' }
    $n = [Math]::Min($Take, $Bytes.Length)
    return ([BitConverter]::ToString($Bytes, 0, $n)).Replace('-', ' ')
}

function Test-StrictUtf8Bytes {
    param([byte[]]$Bytes)
    $strict = [System.Text.Encoding]::GetEncoding(
        'utf-8',
        (New-Object System.Text.EncoderExceptionFallback),
        (New-Object System.Text.DecoderExceptionFallback))
    try { $strict.GetString($Bytes) | Out-Null; return $true } catch { return $false }
}

function Get-Classification {
    param([byte[]]$Bytes)
    if ($Bytes.Length -ge 3 -and $Bytes[0] -eq 0xEF -and $Bytes[1] -eq 0xBB -and $Bytes[2] -eq 0xBF) { return 'UTF-8-BOM' }
    if ($Bytes.Length -ge 2 -and $Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE) { return 'UTF-16LE-BOM' }
    if (Test-StrictUtf8Bytes $Bytes) { return 'UTF-8-NoBOM-or-ASCII' }
    return 'ANSI-GBK-or-other'
}

function Main {
    if ([string]::IsNullOrWhiteSpace($WorkDir)) {
        $WorkDir = Join-Path ([System.IO.Path]::GetTempPath()) 'ps-enc-demo'
    }
    New-Item -ItemType Directory -Path $WorkDir -Force -ErrorAction Stop | Out-Null

    # Sample U+4F60 U+597D U+FF0C U+0055 U+0054 U+0046 U+002D U+0038
    $sample = [string]([char]0x4F60 + [char]0x597D + [char]0xFF0C + [char]0x0055 + [char]0x0054 + [char]0x0046 + [char]0x002D + [char]0x0038)
    $fRedir = Join-Path $WorkDir 'redir-operator.txt'
    $fOut = Join-Path $WorkDir 'redir-outfile.txt'
    $fSet = Join-Path $WorkDir 'redir-setcontent.txt'
    $fUtf8 = Join-Path $WorkDir 'redir-explicit-utf8.txt'
    $fNoBom = Join-Path $WorkDir 'redir-dotnet-nobom.txt'

    $sample | Out-File -LiteralPath $fRedir -Force -ErrorAction Stop
    $sample | Out-File -LiteralPath $fOut -Force -ErrorAction Stop
    $sample | Set-Content -LiteralPath $fSet -Force -ErrorAction Stop
    $sample | Set-Content -LiteralPath $fUtf8 -Encoding UTF8 -Force -ErrorAction Stop
    [System.IO.File]::WriteAllText($fNoBom, $sample, (New-Object System.Text.UTF8Encoding $false))

    foreach ($f in @($fRedir, $fOut, $fSet, $fUtf8, $fNoBom)) {
        $b = [System.IO.File]::ReadAllBytes($f)
        $name = [System.IO.Path]::GetFileName($f)
        Write-Output ($name + ' class=' + (Get-Classification $b) + ' head=' + (ConvertTo-HexLine $b))
    }

    $back = [System.IO.File]::ReadAllText($fNoBom, (New-Object System.Text.UTF8Encoding $false))
    Write-Output ('dotnet-nobom-roundtrip=' + ($back -eq $sample))
    if ($back -ne $sample) { Write-Error 'NoBOM round-trip failed.'; exit 1 }
    exit 0
}

if ($Help) { Show-Usage; exit 0 }
try { Main } catch { Write-Error $_; exit 1 }
