Write-Host "This helper was renamed to p520." -ForegroundColor Yellow
& "$PSScriptRoot\rebuild-test-p520.ps1" @args
exit $LASTEXITCODE
