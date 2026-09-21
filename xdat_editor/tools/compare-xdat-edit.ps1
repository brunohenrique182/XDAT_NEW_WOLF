param(
    [Parameter(Mandatory = $true)]
    [string]$Original,

    [Parameter(Mandatory = $true)]
    [string]$Edited,

    [int]$ContextBytes = 32,
    [int]$MaxRanges = 64
)

$ErrorActionPreference = "Stop"

function Get-Sha256([string]$Path) {
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Format-HexContext([byte[]]$Bytes, [int]$Start, [int]$End, [int]$Context) {
    $from = [Math]::Max(0, $Start - $Context)
    $to = [Math]::Min($Bytes.Length - 1, $End + $Context)

    $lines = New-Object System.Collections.Generic.List[string]
    for ($offset = $from; $offset -le $to; $offset += 16) {
        $lineEnd = [Math]::Min($to, $offset + 15)
        $hex = New-Object System.Collections.Generic.List[string]
        $ascii = New-Object System.Text.StringBuilder

        for ($i = $offset; $i -le $lineEnd; $i++) {
            [void]$hex.Add(("{0:X2}" -f $Bytes[$i]))
            $b = $Bytes[$i]
            if ($b -ge 0x20 -and $b -le 0x7E) {
                [void]$ascii.Append([char]$b)
            } else {
                [void]$ascii.Append(".")
            }
        }

        $mark = if ($lineEnd -ge $Start -and $offset -le $End) { ">" } else { " " }
        [void]$lines.Add(("{0} 0x{1:X8}  {2,-47}  {3}" -f $mark, $offset, ($hex -join " "), $ascii.ToString()))
    }

    $lines
}

if (-not (Test-Path -LiteralPath $Original)) {
    throw "Original file not found: $Original"
}
if (-not (Test-Path -LiteralPath $Edited)) {
    throw "Edited file not found: $Edited"
}

$originalPath = (Resolve-Path -LiteralPath $Original).Path
$editedPath = (Resolve-Path -LiteralPath $Edited).Path

$originalBytes = [System.IO.File]::ReadAllBytes($originalPath)
$editedBytes = [System.IO.File]::ReadAllBytes($editedPath)

Write-Host ""
Write-Host "Wolf p520 XDAT binary edit comparison" -ForegroundColor Cyan
Write-Host "Original : $originalPath"
Write-Host "Edited   : $editedPath"
Write-Host ""
Write-Host ("Original size : {0:N0} bytes (0x{1:X})" -f $originalBytes.Length, $originalBytes.Length)
Write-Host ("Edited size   : {0:N0} bytes (0x{1:X})" -f $editedBytes.Length, $editedBytes.Length)
Write-Host ("Original SHA  : {0}" -f (Get-Sha256 $originalPath))
Write-Host ("Edited SHA    : {0}" -f (Get-Sha256 $editedPath))
Write-Host ""

$commonLength = [Math]::Min($originalBytes.Length, $editedBytes.Length)
$diffOffsets = New-Object System.Collections.Generic.List[int]

for ($i = 0; $i -lt $commonLength; $i++) {
    if ($originalBytes[$i] -ne $editedBytes[$i]) {
        [void]$diffOffsets.Add($i)
    }
}

if ($originalBytes.Length -ne $editedBytes.Length) {
    for ($i = $commonLength; $i -lt [Math]::Max($originalBytes.Length, $editedBytes.Length); $i++) {
        [void]$diffOffsets.Add($i)
    }
}

if ($diffOffsets.Count -eq 0) {
    Write-Host "IDENTICAL: no byte differences." -ForegroundColor Green
    exit 0
}

$ranges = New-Object System.Collections.Generic.List[object]
$rangeStart = $diffOffsets[0]
$previous = $diffOffsets[0]

for ($n = 1; $n -lt $diffOffsets.Count; $n++) {
    $current = $diffOffsets[$n]
    if ($current -ne ($previous + 1)) {
        [void]$ranges.Add([pscustomobject]@{
            Start = $rangeStart
            End = $previous
            Length = ($previous - $rangeStart + 1)
        })
        $rangeStart = $current
    }
    $previous = $current
}

[void]$ranges.Add([pscustomobject]@{
    Start = $rangeStart
    End = $previous
    Length = ($previous - $rangeStart + 1)
})

Write-Host ("Changed bytes  : {0:N0}" -f $diffOffsets.Count) -ForegroundColor Yellow
Write-Host ("Changed ranges : {0:N0}" -f $ranges.Count) -ForegroundColor Yellow
Write-Host ("First diff     : 0x{0:X8} ({0})" -f $diffOffsets[0])
Write-Host ("Last diff      : 0x{0:X8} ({0})" -f $diffOffsets[$diffOffsets.Count - 1])
Write-Host ""

if ($originalBytes.Length -eq $editedBytes.Length -and $diffOffsets.Count -le 8 -and $ranges.Count -le 2) {
    Write-Host "Classification: minimal fixed-size edit." -ForegroundColor Green
    Write-Host "If the Wolf client still rejects this file, investigate validation/index/checksum data rather than structural drift." -ForegroundColor Yellow
} elseif ($originalBytes.Length -eq $editedBytes.Length) {
    Write-Host "Classification: same-size edit with multiple changed regions." -ForegroundColor Yellow
    Write-Host "This may indicate additional properties were normalized/changed during editing." -ForegroundColor Yellow
} else {
    Write-Host "Classification: file size changed." -ForegroundColor Red
    Write-Host "A fixed-size property edit should normally not change XDAT length; inspect serialization immediately." -ForegroundColor Red
}

Write-Host ""
Write-Host "Changed ranges:" -ForegroundColor Cyan

$shown = [Math]::Min($ranges.Count, $MaxRanges)
for ($r = 0; $r -lt $shown; $r++) {
    $range = $ranges[$r]
    Write-Host ("[{0}] 0x{1:X8}-0x{2:X8}  ({3} byte(s))" -f ($r + 1), $range.Start, $range.End, $range.Length)

    if ($range.Start -lt $originalBytes.Length) {
        Write-Host "  Original:"
        Format-HexContext $originalBytes $range.Start ([Math]::Min($range.End, $originalBytes.Length - 1)) $ContextBytes |
            ForEach-Object { Write-Host "    $_" }
    }

    if ($range.Start -lt $editedBytes.Length) {
        Write-Host "  Edited:"
        Format-HexContext $editedBytes $range.Start ([Math]::Min($range.End, $editedBytes.Length - 1)) $ContextBytes |
            ForEach-Object { Write-Host "    $_" }
    }

    Write-Host ""
}

if ($ranges.Count -gt $shown) {
    Write-Host ("... {0} additional range(s) omitted. Increase -MaxRanges to show them." -f ($ranges.Count - $shown)) -ForegroundColor DarkYellow
}

$markers = @(
    "AutomaticPlay",
    "AutoHunt_All_Btn",
    "AutoTargetWnd",
    "AutoTargetWndMin_window",
    "ToggleEffect_Anim",
    "Check_AutoTargetIcon",
    "AutoPlay",
    "YetiQuickSlotWnd",
    "RelicSummonWnd",
    "Varkas"
)

$latin1 = [System.Text.Encoding]::GetEncoding(28591)

function Show-MarkerOffsets([string]$Label, [byte[]]$Bytes) {
    Write-Host $Label -ForegroundColor Cyan
    $raw = $latin1.GetString($Bytes)

    foreach ($marker in $markers) {
        $idx = $raw.IndexOf($marker, [System.StringComparison]::Ordinal)
        if ($idx -ge 0) {
            Write-Host ("  {0,-20} 0x{1:X8} ({1})" -f $marker, $idx)
        } else {
            Write-Host ("  {0,-20} not found" -f $marker) -ForegroundColor Green
        }
    }
}

Write-Host ""
Show-MarkerOffsets "Marker first offsets in original:" $originalBytes
Write-Host ""
Show-MarkerOffsets "Marker first offsets in edited:" $editedBytes

if ($originalBytes.Length -ne $editedBytes.Length) {
    Write-Host ""
    Write-Host ("Net size delta: {0:N0} bytes" -f ($editedBytes.Length - $originalBytes.Length)) -ForegroundColor Cyan
    Write-Host "For structural deletions, a large naive byte-diff is expected because all later bytes shift." -ForegroundColor DarkYellow
    Write-Host "Use the marker table above plus successful reopen/client load to validate removals." -ForegroundColor DarkYellow
}
