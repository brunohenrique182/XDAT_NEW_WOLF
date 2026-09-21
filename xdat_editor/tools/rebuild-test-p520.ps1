param(
    [string]$JavaHome = "C:\Program Files\BellSoft\LibericaJDK-21",
    [string]$JavaFxHome = "$env:USERPROFILE\javafx-sdk-21.0.12"
)

$ErrorActionPreference = "Stop"

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\.."))
$editorDir = Join-Path $repoRoot "xdat_editor"
$distDir = Join-Path $editorDir "dist"

$env:JAVA_HOME = $JavaHome
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

$ant = Get-ChildItem "$env:USERPROFILE\tools" -Recurse -Filter ant.bat -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $ant) {
    throw "Apache Ant was not found under $env:USERPROFILE\tools"
}

$javaExe = Join-Path $JavaHome "bin\java.exe"
if (-not (Test-Path -LiteralPath $javaExe)) {
    throw "Java not found: $JavaHome"
}

$javaFxLib = Join-Path $JavaFxHome "lib"
if (-not (Test-Path -LiteralPath (Join-Path $javaFxLib "javafx.controls.jar"))) {
    throw "JavaFX SDK not found: $JavaFxHome"
}

Write-Host ""
Write-Host "Wolf p520 XDAT rebuild/test" -ForegroundColor Cyan
Write-Host "Repo   : $repoRoot"
Write-Host "Ant    : $ant"
Write-Host "Java   : $JavaHome"
Write-Host "JavaFX : $JavaFxHome"
Write-Host ""


# Windows keeps dependency JARs locked while a previous XDAT Editor JVM is alive.
# Stop only Java processes whose command line belongs to this editor.
$editorProcesses = @(
    Get-CimInstance Win32_Process -Filter "Name='java.exe'" -ErrorAction SilentlyContinue |
        Where-Object {
            $_.CommandLine -and
            $_.CommandLine -match 'xdat-editor-1[.]6[.]2[.]jar'
        }
)

if ($editorProcesses.Count -gt 0) {
    Write-Host "Stopping previous XDAT Editor process(es) before rebuild..." -ForegroundColor Yellow

    foreach ($process in $editorProcesses) {
        Write-Host ("  PID {0}: {1}" -f $process.ProcessId, $process.CommandLine) -ForegroundColor DarkGray
        Stop-Process -Id $process.ProcessId -Force -ErrorAction Stop
    }

    # Give Windows a moment to release loaded JAR handles.
    Start-Sleep -Milliseconds 750
}

Push-Location $repoRoot
try {
    & $ant -f ".\xdat_editor\build.xml" clean dist "-Djavafx.sdk=$JavaFxHome"
    if ($LASTEXITCODE -ne 0) {
        throw "XDAT Editor build failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

$jar = Join-Path $distDir "xdat-editor-1.6.2.jar"
if (-not (Test-Path -LiteralPath $jar)) {
    throw "Built editor JAR not found: $jar"
}

Write-Host ""
Write-Host "Build successful. Starting XDAT Editor..." -ForegroundColor Green
Write-Host "Select: Version -> Wolf Waker / p520 (experimental)" -ForegroundColor Yellow
Write-Host ""

Push-Location $distDir
try {
    & $javaExe --module-path $javaFxLib --add-modules javafx.controls,javafx.fxml,javafx.graphics,javafx.swing -jar ".\xdat-editor-1.6.2.jar"
}
finally {
    Pop-Location
}
