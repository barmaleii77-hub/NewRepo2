#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Демонстрация всех современных возможностей Qt Quick 3D
"""
import sys
import os
from pathlib import Path

# Принудительно включаем все продвинутые функции
os.environ["QSG_RHI_BACKEND"] = "d3d12"  # DirectX 12 для максимальных возможностей
os.environ["QSG_INFO"] = "1"
os.environ["QT_LOGGING_RULES"] = "qt.quick3d.*=true"
os.environ["QT_QUICK3D_FORCE_RENDERER"] = "rhi"

from PySide6.QtWidgets import QApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QUrl, qmlRegisterType
from PySide6.QtGui import QSurfaceFormat

def setup_premium_format():
    """Настройка премиум формата для максимального качества"""
    fmt = QSurfaceFormat()
    fmt.setVersion(4, 6)
    fmt.setProfile(QSurfaceFormat.OpenGLContextProfile.CoreProfile)
    fmt.setDepthBufferSize(32)  # Максимальная глубина
    fmt.setStencilBufferSize(8)
    fmt.setSamples(16)  # 16x MSAA для ультра-качества
    fmt.setSwapBehavior(QSurfaceFormat.SwapBehavior.DoubleBuffer)
    fmt.setSwapInterval(1)
    QSurfaceFormat.setDefaultFormat(fmt)

def main():
    print("🚀" * 50)
    print("ДЕМОНСТРАЦИЯ ВСЕХ ВОЗМОЖНОСТЕЙ QT QUICK 3D")
    print("🚀" * 50)
    print()
    print("🎮 АКТИВИРОВАННЫЕ ФУНКЦИИ:")
    print("   ✨ Advanced PBR Materials (металлы, стекло, пластик)")
    print("   🌟 HDR Rendering Pipeline")
    print("   🔥 Post-Processing Effects:")
    print("      - Bloom (цветение)")
    print("      - SSAO (затенение окружающей среды)")
    print("      - FXAA (сглаживание)")
    print("      - Temporal AA (временное сглаживание)")
    print("   💎 Advanced Materials:")
    print("      - Transmission (прохождение света)")
    print("      - Subsurface Scattering (подповерхностное рассеивание)")
    print("      - IOR (показатель преломления)")
    print("   ⚡ Hardware Shadows:")
    print("      - Cascaded Shadow Maps")
    print("      - Soft Shadows")
    print("   🎯 Advanced Lighting:")
    print("      - Image-Based Lighting (IBL)")
    print("      - Multiple Light Types")
    print("      - Dynamic Light Animation")
    print("   🚀 Performance Features:")
    print("      - GPU Instancing")
    print("      - Level of Detail (LOD)")
    print("      - Frustum Culling")
    print()
    
    setup_premium_format()
    
    app = QApplication(sys.argv)
    
    # Установка продвинутых атрибутов
    app.setAttribute(app.ApplicationAttribute.AA_EnableHighDpiScaling)
    app.setAttribute(app.ApplicationAttribute.AA_UseHighDpiPixmaps)
    
    view = QQuickView()
    view.setResizeMode(QQuickView.ResizeMode.SizeRootObjectToView)
    
    # Загружаем продвинутую версию
    qml_path = Path("assets/qml/main_advanced.qml")
    if not qml_path.exists():
        print("⚠️  Используем обновленный main.qml")
        qml_path = Path("assets/qml/main.qml")
    
    view.setSource(QUrl.fromLocalFile(str(qml_path.absolute())))
    
    view.setTitle("🚀 Advanced Qt Quick 3D - All Features Demo")
    view.resize(1800, 1200)
    view.show()
    
    print("✅ Демо запущено!")
    print()
    print("🎮 УПРАВЛЕНИЕ:")
    print("   🖱️  Левая кнопка мыши - поворот камеры")
    print("   🖱️  Колесико - масштабирование")
    print("   ⌨️  F - автофит к модели")
    print("   ⌨️  R - сброс камеры")
    print("   🖱️  Клик по информационной панели - пауза/воспроизведение")
    print()
    print("👀 ЧТО ИСКАТЬ:")
    print("   ✨ Реалистичные отражения на металлических поверхностях")
    print("   🌟 Цветение (bloom) от ярких источников света")
    print("   💎 Прозрачность и преломление в стеклянных цилиндрах")
    print("   🔥 Мягкие тени от всех объектов")
    print("   ⚡ Плавные анимации с физикой")
    print("   🎯 Динамическое освещение")
    print()
    
    return app.exec()

if __name__ == "__main__":
    sys.exit(main())
