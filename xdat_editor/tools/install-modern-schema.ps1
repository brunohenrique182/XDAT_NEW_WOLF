param(
    [string]$Destination
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://raw.githubusercontent.com/ALN2025/editor-xdat-l2jaln/main/lib/schema.jar"

if ([string]::IsNullOrWhiteSpace($Destination)) {
    $root = Split-Path -Parent $PSScriptRoot
    if ((Split-Path -Leaf $PSScriptRoot) -eq "tools") {
        $pluginDir = Join-Path $root "schema-plugins"
    } else {
        $pluginDir = Join-Path $PSScriptRoot "schema-plugins"
    }
} else {
    $pluginDir = $Destination
}

New-Item -ItemType Directory -Force -Path $pluginDir | Out-Null

$target = Join-Path $pluginDir "aln-modern-schema.jar"
$temp = "$target.download"

Write-Host ""
Write-Host "XDAT modern schema installer" -ForegroundColor Cyan
Write-Host "Source      : $sourceUrl"
Write-Host "Destination : $target"
Write-Host ""

try {
    Invoke-WebRequest -Uri $sourceUrl -OutFile $temp -UseBasicParsing

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::OpenRead($temp)
    try {
        $entries = @($zip.Entries | ForEach-Object { $_.FullName })
        $p502 = $entries | Where-Object { $_ -eq "p502/XDAT.class" }
        $xdatClasses = @($entries | Where-Object { $_ -match '^p\d+/XDAT\.class$' })

        if (-not $p502) {
            throw "Downloaded JAR does not contain p502/XDAT.class. File was not installed."
        }

        Write-Host ("Modern XDAT classes found: {0}" -f $xdatClasses.Count) -ForegroundColor Green
        Write-Host ("Includes: {0}" -f (($xdatClasses | Sort-Object) -join ", "))
    }
    finally {
        $zip.Dispose()
    }

    Move-Item -Force -LiteralPath $temp -Destination $target

    $hash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
    Write-Host ""
    Write-Host "Installed successfully." -ForegroundColor Green
    Write-Host "SHA256: $hash"
    Write-Host ""
    Write-Host "Restart XDAT Editor. New external protocol entries will appear under Version." -ForegroundColor Yellow
}
catch {
    if (Test-Path -LiteralPath $temp) {
        Remove-Item -Force -LiteralPath $temp
    }
    throw
}
