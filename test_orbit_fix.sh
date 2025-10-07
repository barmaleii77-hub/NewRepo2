#!/bin/bash
# Test script for OrbitCameraController fix

echo "🔧 Testing OrbitCameraController fix..."
echo "========================================"

cd "$(dirname "$0")"

# Activate virtual environment
if [ -f "venv/Scripts/activate" ]; then
    source venv/Scripts/activate
elif [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
fi

echo "✅ Virtual environment activated"

# Run with test mode (5 second auto-close)
echo "🧪 Running test mode (5 seconds)..."
python app.py --test-mode --debug

echo ""
echo "🔍 Check console output for:"
echo "  ✅ 'OrbitCameraController initialized successfully'"
echo "  ❌ No 'TypeError: Cannot read property 'eulerRotation' of null'"
echo ""
echo "If no errors appeared, the fix is successful! 🎉"
