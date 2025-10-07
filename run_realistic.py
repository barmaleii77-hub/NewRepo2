import sys
from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtQuickWidgets import QQuickWidget
from PySide6.QtCore import QUrl
from pathlib import Path

app = QApplication(sys.argv)
window = QMainWindow()
window.setWindowTitle("Realistic Suspension 3D")
window.resize(1400, 900)

qml_widget = QQuickWidget()
qml_widget.setResizeMode(QQuickWidget.ResizeMode.SizeRootObjectToView)

qml_path = Path("test_realistic_suspension.qml")
qml_url = QUrl.fromLocalFile(str(qml_path.absolute()))
qml_widget.setSource(qml_url)

if qml_widget.status() == QQuickWidget.Status.Error:
    print("QML Errors:")
    for err in qml_widget.errors():
        print(f"  {err.toString()}")
    sys.exit(1)

print("Realistic Suspension Scene Loaded!")
print("\nComponents:")
print("  - Blue Pneumatic Cylinder (animated)")
print("  - Orange Lever Arm (rotating)")
print("  - Yellow Air Tank")
print("  - Wheel Assembly (bouncing)")
print("  - Frame, Springs, Hoses")
print("  - Grid Floor + Axes")
print("\nControls:")
print("  Drag mouse - Rotate camera")
print("  Mouse wheel - Zoom")
print("  Reset button - Default view")
print("\nClose window to exit...")

window.setCentralWidget(qml_widget)
window.show()
sys.exit(app.exec())
