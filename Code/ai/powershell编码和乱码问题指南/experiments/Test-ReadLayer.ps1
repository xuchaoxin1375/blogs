# Test-ReadLayer.ps1 - file-bytes -> String layer (Get-Content / Select-String).
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File Test-ReadLayer.ps1 [-WorkDir <dir>]
#   pwsh -NoProfile -File Test-ReadLayer.ps1 [-WorkDir <dir>]
# ASCII-only source; non-ASCII samples are built from [char] code points.
[CmdletBinding()]
param(
    [string]$WorkDir = '',
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Output 'Usage: Test-ReadLayer.ps1 [-WorkDir <dir>] [-Help]'
    Write-Output 'Creates utf8-nobom / utf8-bom / gbk fixtures and compares'
    Write-Output 'default read vs -Encoding UTF8 vs -Encoding Default, plus'
    Write-Output 'Select-String match counts. Judged by counts/booleans only.'
}

function ConvertTo-HexLine {
    param([byte[]]$Bytes, [int]$Take = 12)
    if ($null -eq $Bytes -or $Bytes.Length -eq 0) { return '(empty)' }
    $n = [Math]::Min($Take, $Bytes.Length)
    return ([BitConverter]::ToString($Bytes, 0, $n)).Replace('-', ' ')
}

function Test-StrictUtf8 {
    param([byte[]]$Bytes)
    $strict = [System.Text.Encoding]::GetEncoding(
        'utf-8',
        (New-Object System.Text.EncoderExceptionFallback),
        (New-Object System.Text.DecoderExceptionFallback))
    try { $strict.GetString($Bytes) | Out-Null; return $true } catch { return $false }
}

function Main {
    if ([string]::IsNullOrWhiteSpace($WorkDir)) {
        $WorkDir = Join-Path ([System.IO.Path]::GetTempPath()) 'ps-enc-demo'
    }
    New-Item -ItemType Directory -Path $WorkDir -Force -ErrorAction Stop | Out-Null

    # Sample U+4F60 U+597D U+FF0C U+0055 U+0054 U+0046 U+002D U+0038 ("ni-hao,UTF-8")
    $sample = [string]([char]0x4F60 + [char]0x597D + [char]0xFF0C + [char]0x0055 + [char]0x0054 + [char]0x0046 + [char]0x002D + [char]0x0038)
    $keyword = [string][char]0x4F60
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    $utf8Bom = New-Object System.Text.UTF8Encoding $true
    $gbk = [System.Text.Encoding]::GetEncoding(936)

    $fNoBom = Join-Path $WorkDir 'read-utf8-nobom.txt'
    $fBom = Join-Path $WorkDir 'read-utf8-bom.txt'
    $fGbk = Join-Path $WorkDir 'read-gbk.txt'
    [System.IO.File]::WriteAllText($fNoBom, $sample, $utf8NoBom)
    [System.IO.File]::WriteAllText($fBom, $sample, $utf8Bom)
    [System.IO.File]::WriteAllText($fGbk, $sample, $gbk)

    $bNoBom = [System.IO.File]::ReadAllBytes($fNoBom)
    $bBom = [System.IO.File]::ReadAllBytes($fBom)
    Write-Output ('fixture.nobom.head=' + (ConvertTo-HexLine $bNoBom))
    Write-Output ('fixture.bom.head=' + (ConvertTo-HexLine $bBom))
    Write-Output ('strict-utf8.nobom=' + (Test-StrictUtf8 $bNoBom))

    $defaultRead = Get-Content -LiteralPath $fNoBom -Raw -ErrorAction Stop
    $utf8Read = Get-Content -LiteralPath $fNoBom -Encoding UTF8 -Raw -ErrorAction Stop
    $ansiRead = Get-Content -LiteralPath $fNoBom -Encoding Default -Raw -ErrorAction Stop
    $bomDefaultRead = Get-Content -LiteralPath $fBom -Raw -ErrorAction Stop
    Write-Output ('default-read-equals-expected=' + ($defaultRead -eq $sample) + ' (False on PS 5.1, True on PS 7)')
    Write-Output ('utf8-read-equals-expected=' + ($utf8Read -eq $sample) + ' (True on both)')
    Write-Output ('ansi-read-equals-expected=' + ($ansiRead -eq $sample) + ' (False on 5.1; True on 7 where Default=UTF-8)')
    Write-Output ('bom-default-read-equals-expected=' + ($bomDefaultRead -eq $sample) + ' (True: BOM sniffed)')

    $direct = @(Select-String -LiteralPath $fNoBom -Pattern $keyword -ErrorAction Stop).Count
    $piped = @(Get-Content -LiteralPath $fNoBom -Encoding UTF8 -ErrorAction Stop | Select-String -Pattern $keyword).Count
    Write-Output ('select-string.direct.count=' + $direct + ' (UTF-8 assumed, no BOM needed)')
    Write-Output ('select-string.piped.count=' + $piped + ' (deterministic when decoding first)')

    if (($utf8Read -eq $sample) -and (Test-StrictUtf8 $bNoBom) -and ($piped -ge 1)) { exit 0 }
    Write-Error 'Read-layer fixture failed: UTF-8 path should round-trip.'
    exit 1
}

if ($Help) { Show-Usage; exit 0 }
try { Main } catch { Write-Error $_; exit 1 }
