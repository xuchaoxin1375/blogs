# Test-OutputLayer.ps1 - String -> bytes layer ([Console]::OutputEncoding).
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File Test-OutputLayer.ps1
#   pwsh -NoProfile -File Test-OutputLayer.ps1
# ASCII-only source. Verdicts are hex/booleans, never raw glyphs.
[CmdletBinding()]
param(
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Output 'Usage: Test-OutputLayer.ps1 [-Help]'
    Write-Output 'Shows the same String encoded as UTF-8 vs GBK(936), proves a'
    Write-Output 'UTF-8 downstream cannot decode the GBK bytes, and prints'
    Write-Output 'IsOutputRedirected (pipe vs interactive).'
}

function ConvertTo-HexLine {
    param([byte[]]$Bytes)
    if ($null -eq $Bytes -or $Bytes.Length -eq 0) { return '(empty)' }
    return ([BitConverter]::ToString($Bytes)).Replace('-', ' ')
}

function Main {
    # Sample U+4F60 U+597D U+FF0C U+0055 U+0054 U+0046 U+002D U+0038
    $sample = [string]([char]0x4F60 + [char]0x597D + [char]0xFF0C + [char]0x0055 + [char]0x0054 + [char]0x0046 + [char]0x002D + [char]0x0038)
    $utf8 = [System.Text.Encoding]::UTF8
    $gbk = [System.Text.Encoding]::GetEncoding(936)
    $strict = [System.Text.Encoding]::GetEncoding(
        'utf-8',
        (New-Object System.Text.EncoderExceptionFallback),
        (New-Object System.Text.DecoderExceptionFallback))

    $uBytes = $utf8.GetBytes($sample)
    $gBytes = $gbk.GetBytes($sample)
    Write-Output ('utf8.bytes=' + $uBytes.Length + ' hex=' + (ConvertTo-HexLine $uBytes))
    Write-Output ('gbk.bytes=' + $gBytes.Length + ' hex=' + (ConvertTo-HexLine $gBytes))

    $utf8Ok = $false
    try { if ($strict.GetString($uBytes) -eq $sample) { $utf8Ok = $true } } catch { $utf8Ok = $false }
    $gbkAsUtf8 = $true
    try { $strict.GetString($gBytes) | Out-Null; $gbkAsUtf8 = $true } catch { $gbkAsUtf8 = $false }
    Write-Output ('utf8-bytes-decode-as-utf8=' + $utf8Ok + ' (True)')
    Write-Output ('gbk-bytes-decode-as-utf8=' + $gbkAsUtf8 + ' (False: downstream mojibake)')

    $saved = [Console]::OutputEncoding
    try {
        [Console]::OutputEncoding = $gbk
        $viaGbk = [Console]::OutputEncoding.GetBytes($sample)
        [Console]::OutputEncoding = $utf8
        $viaUtf8 = [Console]::OutputEncoding.GetBytes($sample)
        Write-Output ('console(gbk).hex=' + (ConvertTo-HexLine $viaGbk))
        Write-Output ('console(utf8).hex=' + (ConvertTo-HexLine $viaUtf8))
    } finally {
        [Console]::OutputEncoding = $saved
    }
    Write-Output ('IsOutputRedirected=' + [Console]::IsOutputRedirected + ' (True under capture, False interactive)')
    if ($utf8Ok -and (-not $gbkAsUtf8)) { exit 0 }
    Write-Error 'Output-layer invariant broken.'
    exit 1
}

if ($Help) { Show-Usage; exit 0 }
try { Main } catch { Write-Error $_; exit 1 }
