# Test-NativePipe.ps1 - $OutputEncoding effect (PS String -> native stdin).
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File Test-NativePipe.ps1
#   pwsh -NoProfile -File Test-NativePipe.ps1
# ASCII-only source. Live pipe part skips cleanly when python is absent.
[CmdletBinding()]
param(
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Output 'Usage: Test-NativePipe.ps1 [-Help]'
    Write-Output 'Compares ASCII (PS 5.1 default) vs UTF-8 bytes for the same'
    Write-Output 'String, then pipes it to python stdin under each setting and'
    Write-Output 'reports received byte counts. Checks $LASTEXITCODE.'
}

function ConvertTo-HexLine {
    param([byte[]]$Bytes)
    if ($null -eq $Bytes -or $Bytes.Length -eq 0) { return '(empty)' }
    return ([BitConverter]::ToString($Bytes)).Replace('-', ' ')
}

function Main {
    # Sample U+4F60 U+597D U+FF0C U+0055 U+0054 U+0046 U+002D U+0038
    $sample = [string]([char]0x4F60 + [char]0x597D + [char]0xFF0C + [char]0x0055 + [char]0x0054 + [char]0x0046 + [char]0x002D + [char]0x0038)
    $ascii = [System.Text.Encoding]::ASCII
    $utf8 = [System.Text.Encoding]::UTF8

    $aBytes = $ascii.GetBytes($sample)
    $uBytes = $utf8.GetBytes($sample)
    Write-Output ('ascii.bytes=' + $aBytes.Length + ' hex=' + (ConvertTo-HexLine $aBytes) + ' (non-ASCII becomes 3F=? )')
    Write-Output ('utf8.bytes=' + $uBytes.Length + ' hex=' + (ConvertTo-HexLine $uBytes))
    Write-Output ('default.OutputEncoding=' + $OutputEncoding.WebName)

    $py = Get-Command python -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $py) { $py = Get-Command python3 -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1 }
    if ($null -eq $py) {
        Write-Output 'live-pipe=SKIP (no python/python3 on PATH)'
        exit 0
    }
    $exe = $py.Source
    $probe = 'import sys; sys.stdout.write(str(len(sys.stdin.buffer.read())))'
    $saved = $OutputEncoding
    try {
        $OutputEncoding = $ascii
        $gotAscii = ($sample | & $exe -X utf8 -c $probe)
        if ($LASTEXITCODE -ne 0) { throw 'python probe failed under ASCII setting' }
        $OutputEncoding = $utf8
        $gotUtf8 = ($sample | & $exe -X utf8 -c $probe)
        if ($LASTEXITCODE -ne 0) { throw 'python probe failed under UTF-8 setting' }
        Write-Output ('live-pipe.ascii.received-bytes=' + $gotAscii)
        Write-Output ('live-pipe.utf8.received-bytes=' + $gotUtf8)
        Write-Output ('live-pipe.utf8-longer-than-ascii=' + ([int]$gotUtf8 -gt [int]$gotAscii))
    } finally {
        $OutputEncoding = $saved
    }
    exit 0
}

if ($Help) { Show-Usage; exit 0 }
try { Main } catch { Write-Error $_; exit 1 }
