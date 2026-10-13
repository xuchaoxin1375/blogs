# Show-EncodingDefaults.ps1 - show encoding-related variables and defaults.
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File Show-EncodingDefaults.ps1
#   pwsh -NoProfile -File Show-EncodingDefaults.ps1
# Notes:
#   - This file is ASCII-only on purpose so Windows PowerShell 5.1 parses it
#     without requiring a BOM.
#   - Verdicts use ASCII hex/counts so piped capture stays reliable.
[CmdletBinding()]
param(
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Output 'Usage: Show-EncodingDefaults.ps1 [-Help]'
    Write-Output 'Prints PS version plus OutputEncoding, Console encodings,'
    Write-Output 'DotNet Default, IsOutputRedirected, and sample hex (UTF-8 vs Default).'
}

function ConvertTo-HexLine {
    param([byte[]]$Bytes)
    if ($null -eq $Bytes -or $Bytes.Length -eq 0) { return '(empty)' }
    return ([BitConverter]::ToString($Bytes)).Replace('-', ' ')
}

function Main {
    # Sample " applause? " built from code points: U+4F60 U+597D U+FF0C U+0055 U+0054 U+0046 U+002D U+0038
    $sample = [string]([char]0x4F60 + [char]0x597D + [char]0xFF0C + [char]0x0055 + [char]0x0054 + [char]0x0046 + [char]0x002D + [char]0x0038)
    $utf8 = [System.Text.Encoding]::UTF8
    $def = [System.Text.Encoding]::Default

    Write-Output ('PSVersion=' + $PSVersionTable.PSVersion.ToString() + ' PSEdition=' + $PSVersionTable.PSEdition)
    Write-Output ('OutputEncoding=' + $OutputEncoding.WebName + ' CodePage=' + $OutputEncoding.CodePage)
    Write-Output ('Console.OutputEncoding=' + [Console]::OutputEncoding.WebName + ' CodePage=' + [Console]::OutputEncoding.CodePage)
    Write-Output ('Console.InputEncoding=' + [Console]::InputEncoding.WebName + ' CodePage=' + [Console]::InputEncoding.CodePage)
    Write-Output ('DotNet.Default=' + $def.WebName + ' CodePage=' + $def.CodePage)
    Write-Output ('IsOutputRedirected=' + [Console]::IsOutputRedirected)

    $utf8Bytes = $utf8.GetBytes($sample)
    $defBytes = $def.GetBytes($sample)
    Write-Output ('sample.length(chars)=' + $sample.Length)
    Write-Output ('sample.utf8.bytes=' + $utf8Bytes.Length + ' hex=' + (ConvertTo-HexLine $utf8Bytes))
    Write-Output ('sample.default.bytes=' + $defBytes.Length + ' hex=' + (ConvertTo-HexLine $defBytes))
}

if ($Help) { Show-Usage; exit 0 }
try { Main; exit 0 } catch { Write-Error $_; exit 1 }
