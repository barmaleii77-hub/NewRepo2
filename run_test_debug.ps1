# Qt Quick 3D Test with Debug Output
Write-Host "======================================================================"
Write-Host "Qt Quick 3D Test with RHI Backend Debug"
Write-Host "======================================================================"
Write-Host ""

# Set environment variables
$env:QSG_INFO = "1"
$env:QSG_RHI_BACKEND = "d3d11"
$env:QT_LOGGING_RULES = "qt.scenegraph*=true,qt.rhi*=true,qt.quick3d*=true"

Write-Host "Environment set:"
Write-Host "  QSG_INFO=1"
Write-Host "  QSG_RHI_BACKEND=d3d11"
Write-Host "  QT_LOGGING_RULES=qt.scenegraph*,qt.rhi*,qt.quick3d*"
Write-Host ""
Write-Host "======================================================================"
Write-Host "Running minimal test..."
Write-Host "======================================================================"
Write-Host ""

# Run test
& "C:\Users\Алексей\.venv\Scripts\python.exe" test_minimal.py

Write-Host ""
Write-Host "======================================================================"
Write-Host "Test complete. Check output above for:"
Write-Host "  - RHI backend initialization"
Write-Host "  - Qt Quick 3D renderer info"
Write-Host "  - Scene graph compilation"
Write-Host "======================================================================"
