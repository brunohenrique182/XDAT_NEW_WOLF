param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "File not found: $Path"
}

$resolved = (Resolve-Path -LiteralPath $Path).Path
[byte[]]$bytes = [System.IO.File]::ReadAllBytes($resolved)

function Find-AsciiOffset {
    param(
        [byte[]]$Data,
        [string]$Text
    )

    [byte[]]$needle = [System.Text.Encoding]::ASCII.GetBytes($Text)
    if ($needle.Length -eq 0 -or $needle.Length -gt $Data.Length) {
        return -1L
    }

    for ($i = 0; $i -le $Data.Length - $needle.Length; $i++) {
        if ($Data[$i] -ne $needle[0]) {
            continue
        }

        $match = $true
        for ($j = 1; $j -lt $needle.Length; $j++) {
            if ($Data[$i + $j] -ne $needle[$j]) {
                $match = $false
                break
            }
        }

        if ($match) {
            return [long]$i
        }
    }

    return -1L
}

$markers = [ordered]@{
    "AutomaticPlay"    = "AutomaticPlay"
    "AutoHunt_All_Btn" = "AutoHunt_All_Btn"
    "YetiQuickSlotWnd" = "YetiQuickSlotWnd"
    "RelicSummonWnd"   = "RelicSummonWnd"
    "RelicCollection"  = "RelicCollection"
    "Varkas"           = "Varkas"
    "AssassinOnly"     = "AssassinOnly"
    "CollectionSystem" = "CollectionSystem"
    "Homunculus"       = "Homunculus"
}

Write-Host ""
Write-Host "XDAT modern-format inspector" -ForegroundColor Cyan
Write-Host "File : $resolved"
Write-Host ("Size : {0:N0} bytes (0x{1:X})" -f $bytes.LongLength, $bytes.LongLength)
Write-Host ("SHA256: {0}" -f (Get-FileHash -LiteralPath $resolved -Algorithm SHA256).Hash)
Write-Host ""
Write-Host "Markers:" -ForegroundColor Cyan

$found = @{}
foreach ($entry in $markers.GetEnumerator()) {
    $offset = Find-AsciiOffset -Data $bytes -Text $entry.Value
    $found[$entry.Key] = $offset

    if ($offset -ge 0) {
        Write-Host ("  [FOUND] {0,-18} @ 0x{1:X}" -f $entry.Key, $offset) -ForegroundColor Green
    } else {
        Write-Host ("  [-----] {0}" -f $entry.Key)
    }
}

$hasRelic = ($found["RelicSummonWnd"] -ge 0) -or ($found["RelicCollection"] -ge 0)
$hasVarkas = $found["Varkas"] -ge 0
$hasAutoPlay = ($found["AutomaticPlay"] -ge 0) -or ($found["AutoHunt_All_Btn"] -ge 0)
$modernCount = @("AssassinOnly", "CollectionSystem", "Homunculus") |
    Where-Object { $found[$_] -ge 0 } |
    Measure-Object |
    Select-Object -ExpandProperty Count

Write-Host ""
Write-Host "Assessment:" -ForegroundColor Cyan

if ($hasRelic -and $hasVarkas) {
    Write-Host "  Modern Varkas-era XDAT detected." -ForegroundColor Green
    Write-Host "  Working hypothesis: p502-family XDAT serialization (heuristic, not yet proven)." -ForegroundColor Yellow
} elseif ($hasAutoPlay -and $hasRelic -and $modernCount -gt 0) {
    Write-Host "  Modern post-Salvation XDAT detected." -ForegroundColor Green
    Write-Host "  The bundled etoa5/Salvation schema is not safe for this file." -ForegroundColor Yellow
} else {
    Write-Host "  No strong Wolf/Varkas-era fingerprint detected."
}

if ($hasAutoPlay) {
    Write-Host "  Auto Hunt / Automatic Play UI markers are present." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Important: this tool is read-only; it does not modify the XDAT." -ForegroundColor DarkGray
