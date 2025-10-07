# Qt Quick 3D Detailed Debug Test
Write-Host "======================================================================"  -ForegroundColor Green
Write-Host "Qt Quick 3D DETAILED DIAGNOSTIC TEST"  -ForegroundColor Green
Write-Host "======================================================================"  -ForegroundColor Green
Write-Host ""

# Set environment variables with correct logging format
$env:QSG_INFO = "1"
$env:QSG_RHI_BACKEND = "d3d11"
$env:QT_LOGGING_RULES = "qt.scenegraph.general=true;qt.rhi.general=true;qt.quick3d=true"

Write-Host "Graphics Device Detected:" -ForegroundColor Cyan
Write-Host "  NVIDIA GeForce RTX 5060 Ti"  -ForegroundColor Yellow
Write-Host ""
Write-Host "Environment configured:" -ForegroundColor Cyan
Write-Host "  Backend: D3D11 (DirectX 11)" -ForegroundColor White
Write-Host "  Debug: Scene Graph + RHI + Quick3D" -ForegroundColor White
Write-Host ""
Write-Host "======================================================================"  -ForegroundColor Green
Write-Host "Running test..." -ForegroundColor Green
Write-Host "======================================================================"  -ForegroundColor Green
Write-Host ""

# Run test
& "C:\Users\Алексей\.venv\Scripts\python.exe" test_minimal.py

Write-Host ""
Write-Host "======================================================================"  -ForegroundColor Green
Write-Host "ANALYSIS:"  -ForegroundColor Green
Write-Host "======================================================================"  -ForegroundColor Green
Write-Host ""
Write-Host "Expected output:" -ForegroundColor Cyan
Write-Host "  1. RHI backend: D3D11" -ForegroundColor White
Write-Host "  2. Adapter: NVIDIA GeForce RTX 5060 Ti"  -ForegroundColor White
Write-Host "  3. Texture atlas created" -ForegroundColor White
Write-Host ""
Write-Host "In the window you should see:" -ForegroundColor Cyan
Write-Host "  - Dark gray background" -ForegroundColor White
Write-Host "  - GIANT RED SPHERE (if visible = 3D works!)" -ForegroundColor Red
Write-Host "  - Green info box overlay" -ForegroundColor Green
Write-Host ""
Write-Host "If you see ONLY green box, NO red sphere:" -ForegroundColor Yellow
Write-Host "  -> 3D objects are NOT rendering despite RHI working" -ForegroundColor Yellow
Write-Host "  -> Possible issue: Camera/Light/Model setup" -ForegroundColor Yellow
Write-Host ""
Write-Host "======================================================================"  -ForegroundColor Green
