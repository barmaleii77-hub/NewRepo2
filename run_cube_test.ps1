# Interactive Cube Test with Full Debug
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "INTERACTIVE 3D CUBE TEST - WITH DEBUG OUTPUT" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Set debug environment
$env:QSG_INFO = "1"
$env:QSG_RHI_BACKEND = "d3d11"
$env:QT_LOGGING_RULES = "qt.scenegraph.general=true;qt.rhi.general=true;qt.quick3d=true"

Write-Host "Environment:" -ForegroundColor Yellow
Write-Host "  Backend: D3D11" -ForegroundColor White
Write-Host "  Debug: Full Qt logging enabled" -ForegroundColor White
Write-Host ""
Write-Host "GPU: NVIDIA GeForce RTX 5060 Ti" -ForegroundColor Green
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Starting application..." -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Run
& "C:\Users\Алексей\.venv\Scripts\python.exe" test_cube_interactive.py

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "EXPECTED BEHAVIOR:" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Visual:" -ForegroundColor Yellow
Write-Host "  ? Red cube rotating in center" -ForegroundColor White
Write-Host "  ? RGB coordinate axes visible" -ForegroundColor White
Write-Host "  ? Gray ground plane at bottom" -ForegroundColor White
Write-Host "  ? 3 lights illuminating the scene" -ForegroundColor White
Write-Host ""
Write-Host "Controls:" -ForegroundColor Yellow
Write-Host "  ? Drag mouse - Camera rotates around cube" -ForegroundColor White
Write-Host "  ? Mouse wheel - Zoom in/out (100-1000 units)" -ForegroundColor White
Write-Host "  ? Reset button - Returns to default view" -ForegroundColor White
Write-Host ""
Write-Host "Info Display:" -ForegroundColor Yellow
Write-Host "  ? Camera distance updates when zooming" -ForegroundColor White
Write-Host "  ? Yaw/Pitch angles update when rotating" -ForegroundColor White
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Did it work? Report back:" -ForegroundColor Green
Write-Host "  A) Cube visible and rotating - 3D WORKS!" -ForegroundColor White
Write-Host "  B) Only UI visible, no cube - 3D objects not rendering" -ForegroundColor White
Write-Host "  C) Error/crash - Need more diagnostics" -ForegroundColor White
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
