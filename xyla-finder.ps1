Clear-Host

$tempPath = $env:TEMP
$targetFiles = @("Module.dll", "loader.dll")

Write-Host "  ========================================" -ForegroundColor White
Write-Host "  ||          Xyla Finder                ||" -ForegroundColor White
Write-Host "  ========================================" -ForegroundColor White
Write-Host ""
Write-Host "  | Scanning temp folders for Module.dll + loader.dll..." -ForegroundColor Yellow
Write-Host ""

$folders = Get-ChildItem -Path $tempPath -Directory -Force -ErrorAction SilentlyContinue
$foundFolders = @()

foreach ($folder in $folders) {
    $allFound = $true
    foreach ($file in $targetFiles) {
        if (-not (Test-Path (Join-Path $folder.FullName $file))) {
            $allFound = $false
            break
        }
    }

    if ($allFound) {
        $foundFolders += $folder
    }
}

if ($foundFolders.Count -gt 0) {
    $counter = 1
    foreach ($folder in $foundFolders) {
        $moduleDll = Get-Item (Join-Path $folder.FullName "Module.dll")
        $loaderDll = Get-Item (Join-Path $folder.FullName "loader.dll")

        Write-Host "  |" -ForegroundColor White
        Write-Host "  | Detect Logs ($counter)" -ForegroundColor Red
        Write-Host "  |   Folder: $($folder.FullName)" -ForegroundColor White
        Write-Host "  |" -ForegroundColor White
        Write-Host "  |   Module.dll" -ForegroundColor Cyan
        Write-Host "  |     Date Modified: $($moduleDll.LastWriteTime)" -ForegroundColor Magenta
        Write-Host "  |     Size: $([math]::Round($moduleDll.Length / 1KB, 2)) KB" -ForegroundColor Magenta
        Write-Host "  |" -ForegroundColor White
        Write-Host "  |   loader.dll" -ForegroundColor Cyan
        Write-Host "  |     Date Modified: $($loaderDll.LastWriteTime)" -ForegroundColor Magenta
        Write-Host "  |     Size: $([math]::Round($loaderDll.Length / 1KB, 2)) KB" -ForegroundColor Magenta
        Write-Host "  |" -ForegroundColor White
        Write-Host "  |--------------------------------------" -ForegroundColor White
        Write-Host ""

        $counter++
    }
} else {
    Write-Host "  | No matching folders found." -ForegroundColor Yellow
}

Write-Host "  ========================================" -ForegroundColor White
Write-Host "  ||           SCAN COMPLETE             ||" -ForegroundColor White
Write-Host "  ========================================" -ForegroundColor White
Write-Host ""

if ($foundFolders.Count -eq 0) {
    Write-Host "  | Nothing detected." -ForegroundColor Yellow
} else {
    Write-Host "  | Detected $($foundFolders.Count) folder(s) with both DLLs." -ForegroundColor Green
}

Write-Host ""
Write-Host "  | $([char]27)[1mXyla sucks$([char]27)[0m" -ForegroundColor Red
