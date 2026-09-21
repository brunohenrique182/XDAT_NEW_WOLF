param(
    [string]$Destination
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://raw.githubusercontent.com/ALN2025/editor-xdat-l2jaln/main/lib/schema.jar"

if ([string]::IsNullOrWhiteSpace($Destination)) {
    $root = Split-Path -Parent $PSScriptRoot

    if ((Split-Path -Leaf $PSScriptRoot) -eq "tools") {
        $pluginDir = Join-Path $root "schema-plugins"
    }
    else {
        $pluginDir = Join-Path $PSScriptRoot "schema-plugins"
    }
}
else {
    $pluginDir = [System.IO.Path]::GetFullPath(
        (Join-Path (Get-Location) $Destination)
    )
}

New-Item -ItemType Directory -Force -Path $pluginDir | Out-Null

$target = Join-Path $pluginDir "aln-modern-schema.jar"
$temp = "$target.download"

Write-Host ""
Write-Host "XDAT external schema inspector/installer" -ForegroundColor Cyan
Write-Host "Source      : $sourceUrl"
Write-Host "Destination : $target"
Write-Host ""

try {
    if (Test-Path -LiteralPath $temp) {
        Remove-Item -Force -LiteralPath $temp
    }

    Write-Host "Downloading schema package..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $sourceUrl -OutFile $temp -UseBasicParsing

    if (-not (Test-Path -LiteralPath $temp)) {
        throw "Schema download did not create the expected temporary file."
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $zip = [System.IO.Compression.ZipFile]::OpenRead($temp)

    try {
        $entries = @(
            $zip.Entries |
                ForEach-Object { $_.FullName }
        )

        $allXdatClasses = @(
            $entries |
                Where-Object { $_ -match '^[^/]+/XDAT[.]class$' } |
                Sort-Object -Unique
        )

        $numberedXdatClasses = @(
            $entries |
                Where-Object { $_ -match '^p[0-9]+/XDAT[.]class$' } |
                Sort-Object -Unique
        )

        $hasP509 = $entries -contains "p509/XDAT.class"
        $hasP502 = $entries -contains "p502/XDAT.class"

        Write-Host ""
        Write-Host ("All XDAT schemas found: {0}" -f $allXdatClasses.Count) -ForegroundColor Green

        if ($allXdatClasses.Count -gt 0) {
            foreach ($class in $allXdatClasses) {
                Write-Host ("  {0}" -f $class)
            }
        }
        else {
            Write-Host "  No */XDAT.class entries found." -ForegroundColor Yellow
        }

        Write-Host ""
        Write-Host ("Numbered p### schemas found: {0}" -f $numberedXdatClasses.Count) -ForegroundColor Green

        if ($numberedXdatClasses.Count -gt 0) {
            foreach ($class in $numberedXdatClasses) {
                Write-Host ("  {0}" -f $class)
            }
        }
        else {
            Write-Host "  None." -ForegroundColor Yellow
        }

        Write-Host ""

        if ($hasP509) {
            Write-Host "Candidate p509/XDAT.class is present." -ForegroundColor Green
        }
        elseif ($hasP502) {
            Write-Host "p502/XDAT.class is present, but p509 is absent." -ForegroundColor Yellow
        }
        else {
            Write-Host "Neither p509 nor p502 is present in this package." -ForegroundColor Yellow
            Write-Host "The package will still be installed for inspection, but do NOT use it to save the Wolf XDAT unless a matching schema is verified." -ForegroundColor Yellow
        }
    }
    finally {
        $zip.Dispose()
    }

    Move-Item -Force -LiteralPath $temp -Destination $target

    $hash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash

    Write-Host ""
    Write-Host "Schema package installed for inspection." -ForegroundColor Green
    Write-Host "SHA256: $hash"
    Write-Host ""
    Write-Host "Restart XDAT Editor after this step." -ForegroundColor Yellow
}
catch {
    if (Test-Path -LiteralPath $temp) {
        Remove-Item -Force -LiteralPath $temp
    }

    throw
}
