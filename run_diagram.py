import sys
from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtQuickWidgets import QQuickWidget
from PySide6.QtCore import QUrl
from pathlib import Path

print("=" * 80)
print("PNEUMATIC SUSPENSION - ANIMATED KINEMATIC DIAGRAM")
print("=" * 80)
print("\nAccording to P13 Specification:\n")
print("GEOMETRY (per wheel plane):")
print("  X: transverse from frame to wheel (+ outward)")
print("  Y: vertical (+ up)")
print("  Lever angle theta from X axis (CCW positive)\n")
print("COMPONENTS:")
print("  - Pivot at origin (orange sphere)")
print("  - Lever arm length L (orange cylinder)")
print("  - Rod attachment at rho*L (blue sphere)")
print("  - Free end at L (green sphere + wheel)")
print("  - Cylinder: frame hinge to rod attachment (blue)\n")
print("ANIMATION:")
print("  Free end Y oscillates +/- 150mm")
print("  Lever angle changes accordingly")
print("  Cylinder extends/compresses\n")
print("CONTROLS:")
print("  Mouse drag - Rotate view")
print("  Mouse wheel - Zoom")
print("  Reset button - Default view\n")
print("=" * 80)

app = QApplication(sys.argv)
window = QMainWindow()
window.setWindowTitle("Pneumatic Suspension - Kinematic Diagram (P13)")
window.resize(1400, 900)

qml_widget = QQuickWidget()
qml_widget.setResizeMode(QQuickWidget.ResizeMode.SizeRootObjectToView)

qml_path = Path("test_suspension_diagram.qml")
qml_url = QUrl.fromLocalFile(str(qml_path.absolute()))
qml_widget.setSource(qml_url)

if qml_widget.status() == QQuickWidget.Status.Error:
    print("\nQML ERRORS:")
    for err in qml_widget.errors():
        print(f"  {err.toString()}")
    sys.exit(1)

print("\nDiagram loaded successfully!\n")
print("You should see:")
print("  [OK] Coordinate axes (X=red, Y=green)")
print("  [OK] Frame beam (dark gray)")
print("  [OK] Lever arm (orange)")
print("  [OK] Pivot point (orange sphere)")
print("  [OK] Rod attachment (blue sphere)")
print("  [OK] Free end (green sphere)")
print("  [OK] Pneumatic cylinder (blue)")
print("  [OK] Wheel (black circle)")
print("  [OK] Animation (up-down motion)")
print("  [OK] Real-time parameters display\n")
print("Close window to exit...")
print("=" * 80)

window.setCentralWidget(qml_widget)
window.show()
sys.exit(app.exec())
