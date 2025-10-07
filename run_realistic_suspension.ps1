# Realistic Pneumatic Suspension 3D Visualization
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "    REALISTIC PNEUMATIC SUSPENSION - 3D VISUALIZATION" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "COMPONENTS:" -ForegroundColor Yellow
Write-Host "  [" -NoNewline -ForegroundColor White
Write-Host "BLUE" -NoNewline -ForegroundColor Blue
Write-Host "]   Pneumatic Cylinder (animated piston)" -ForegroundColor White
Write-Host "  [" -NoNewline -ForegroundColor White
Write-Host "ORANGE" -NoNewline -ForegroundColor DarkYellow
Write-Host "] Lever Arm (rotating linkage)" -ForegroundColor White
Write-Host "  [" -NoNewline -ForegroundColor White
Write-Host "YELLOW" -NoNewline -ForegroundColor Yellow
Write-Host "] Air Reservoir (pressure tank)" -ForegroundColor White
Write-Host "  [" -NoNewline -ForegroundColor White
Write-Host "CHROME" -NoNewline -ForegroundColor Gray
Write-Host "] Wheel Assembly (tire + rim)" -ForegroundColor White
Write-Host "  [" -NoNewline -ForegroundColor White
Write-Host "GRAY" -NoNewline -ForegroundColor DarkGray
Write-Host "]   Vehicle Frame + Floor Grid" -ForegroundColor White
Write-Host ""

Write-Host "CONTROLS:" -ForegroundColor Yellow
Write-Host "  Mouse Drag  -> Rotate camera around suspension" -ForegroundColor White
Write-Host "  Mouse Wheel -> Zoom in/out (200-1500 units)" -ForegroundColor White
Write-Host "  Reset Button -> Return to default view" -ForegroundColor White
Write-Host ""

Write-Host "ANIMATIONS:" -ForegroundColor Yellow
Write-Host "  * Piston rod extends/retracts (4 sec cycle)" -ForegroundColor White
Write-Host "  * Lever rotates +/-25 degrees (5 sec cycle)" -ForegroundColor White
Write-Host "  * Wheel bounces up/down (3 sec cycle)" -ForegroundColor White
Write-Host ""

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Starting visualization..." -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Run
& "C:\Users\Алексей\.venv\Scripts\python.exe" run_realistic.py

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Visualization closed" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
