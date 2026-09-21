param(
    [string]$Archive = ".\xdat-aden.zip"
)

$ErrorActionPreference = "Stop"

function Get-FullPath {
    param([string]$Path)
    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }
    return [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Path))
}

function Inspect-ArchiveFile {
    param(
        [string]$Path,
        [string]$Label,
        [int]$Depth = 0
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $indent = "  " * $Depth
    Write-Host ""
    Write-Host ("{0}=== {1} ===" -f $indent, $Label) -ForegroundColor Cyan
    Write-Host ("{0}{1}" -f $indent, $Path)

    $zip = [System.IO.Compression.ZipFile]::OpenRead($Path)
    try {
        $entries = @($zip.Entries)

        Write-Host ("{0}Entries: {1}" -f $indent, $entries.Count)

        $xdatClasses = @(
            $entries |
                ForEach-Object { $_.FullName } |
                Where-Object { $_ -match '(^|/)[^/]+/XDAT[.]class$' } |
                Sort-Object -Unique
        )

        $versionFiles = @(
            $entries |
                ForEach-Object { $_.FullName } |
                Where-Object { $_ -match '(^|/)versions[.]csv$' } |
                Sort-Object -Unique
        )

        $interesting = @(
            $entries |
                Where-Object {
                    $_.FullName -match '(?i)(schema|xdat|aden|interface|version|protocol)' -or
                    $_.FullName -match '(?i)[.](jar|zip)$'
                } |
                Sort-Object FullName
        )

        if ($xdatClasses.Count -gt 0) {
            Write-Host ("{0}XDAT schema classes:" -f $indent) -ForegroundColor Green
            foreach ($name in $xdatClasses) {
                Write-Host ("{0}  {1}" -f $indent, $name)
            }
        }

        if ($versionFiles.Count -gt 0) {
            Write-Host ("{0}versions.csv files:" -f $indent) -ForegroundColor Green
            foreach ($name in $versionFiles) {
                Write-Host ("{0}  {1}" -f $indent, $name)
            }
        }

        Write-Host ("{0}Interesting entries:" -f $indent) -ForegroundColor Yellow
        foreach ($entry in $interesting | Select-Object -First 200) {
            Write-Host ("{0}  {1,-80} {2,12} bytes" -f $indent, $entry.FullName, $entry.Length)
        }

        $nested = @(
            $entries |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_.Name) -and
                    $_.FullName -match '(?i)[.](jar|zip)$'
                }
        )

        if ($Depth -lt 2 -and $nested.Count -gt 0) {
            $tempRoot = Join-Path $env:TEMP ("xdat-aden-inspect-" + [Guid]::NewGuid().ToString("N"))
            New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

            try {
                foreach ($entry in $nested) {
                    $safeName = ($entry.FullName -replace '[\\/:*?"<>|]', '_')
                    $tempFile = Join-Path $tempRoot $safeName

                    $input = $entry.Open()
                    try {
                        $output = [System.IO.File]::Create($tempFile)
                        try {
                            $input.CopyTo($output)
                        }
                        finally {
                            $output.Dispose()
                        }
                    }
                    finally {
                        $input.Dispose()
                    }

                    try {
                        Inspect-ArchiveFile -Path $tempFile -Label $entry.FullName -Depth ($Depth + 1)
                    }
                    catch {
                        Write-Host ("{0}  Could not inspect nested archive {1}: {2}" -f $indent, $entry.FullName, $_.Exception.Message) -ForegroundColor DarkYellow
                    }
                }
            }
            finally {
                Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
    finally {
        $zip.Dispose()
    }
}

$archivePath = Get-FullPath $Archive

if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
    throw "Archive not found: $archivePath"
}

Write-Host ""
Write-Host "XDAT Aden package inspector" -ForegroundColor Cyan
Write-Host "Archive: $archivePath"
Write-Host ("SHA256 : {0}" -f (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash)

Inspect-ArchiveFile -Path $archivePath -Label ([System.IO.Path]::GetFileName($archivePath))

Write-Host ""
Write-Host "Inspection complete. This script is read-only." -ForegroundColor DarkGray
