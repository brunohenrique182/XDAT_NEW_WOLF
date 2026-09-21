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
        $xdatClasses = @($entries | Where-Object { $_ -match '^p\d+/XDAT\.class    }
    finally {
        $zip.Dispose()
    }

    Move-Item -Force -LiteralPath $temp -Destination $target

    $hash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
    Write-Host ""
    Write-Host "Schema package installed for protocol inspection." -ForegroundColor Green
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
 })
        $p509 = $entries | Where-Object { $_ -eq "p509/XDAT.class" }
        $p502 = $entries | Where-Object { $_ -eq "p502/XDAT.class" }

        Write-Host ("Numbered XDAT classes found: {0}" -f $xdatClasses.Count) -ForegroundColor Green

        if ($xdatClasses.Count -gt 0) {
            Write-Host ("Includes: {0}" -f (($xdatClasses | Sort-Object) -join ", "))
        }
        else {
            Write-Host "Includes: no p###/XDAT.class protocols were found." -ForegroundColor Yellow
        }

        if ($p509) {
            Write-Host "Target candidate p509/XDAT.class is present." -ForegroundColor Green
        }
        elseif ($p502) {
            Write-Host "p502/XDAT.class is present, but Wolf/Varkas may require a newer p509 layout." -ForegroundColor Yellow
        }
        else {
            Write-Host "Neither p509 nor p502 is present in this JAR." -ForegroundColor Yellow
            Write-Host "It will be installed only for inspection; do not use it to save the Wolf XDAT unless a matching protocol is confirmed." -ForegroundColor Yellow
        }
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
