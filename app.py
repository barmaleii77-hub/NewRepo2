# -*- coding: utf-8 -*-
"""
PneumoStabSim - Official Qt Quick 3D 6.9.3 Pneumatic Stabilizer Simulator
Based on official Qt documentation and best practices
"""
import sys
import os
import logging
import signal
import argparse
import time
from pathlib import Path

# CRITICAL: Force UTF-8 encoding for stdout to handle emoji in Windows console
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, errors='replace')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, errors='replace')

# ========== OFFICIAL QT QUICK 3D 6.9.3 CONFIGURATION ==========
USE_QML_3D_SCHEMA = True  # True: Official Qt Quick 3D 6.9.3, False: legacy OpenGL

# Official RHI backends supported by Qt Quick 3D 6.9.3
SUPPORTED_RHI_BACKENDS = {
    "windows": ["d3d11", "d3d12", "vulkan", "opengl"],
    "darwin": ["metal", "opengl"],
    "linux": ["vulkan", "opengl"]
}

def get_optimal_rhi_backend():
    """Get optimal RHI backend based on official Qt Quick 3D recommendations"""
    import platform
    system = platform.system().lower()
    
    if system == "windows":
        # Official recommendation: D3D11 for compatibility, D3D12 for latest features
        return "d3d11"  # Most stable on Windows
    elif system == "darwin":  # macOS
        return "metal"  # Native Apple GPU API
    else:  # Linux
        return "vulkan"  # Best performance on Linux

# Set optimal backend
optimal_backend = get_optimal_rhi_backend()
os.environ.setdefault("QSG_RHI_BACKEND", optimal_backend)
os.environ.setdefault("QSG_INFO", "1")

# Official Qt Quick 3D 6.9.3 environment variables
os.environ.setdefault("QT_LOGGING_RULES", 
    "qt.qml.debug=false;"  # Reduce debug spam
    "qt.quick3d.general=false;"
    "js.debug=true"  # Keep JavaScript console.log
)
os.environ.setdefault("QT_ASSUME_STDERR_HAS_CONSOLE", "1")

# Performance optimizations (official recommendations)
if sys.platform == 'win32':
    os.environ.setdefault("QSG_RENDER_LOOP", "windows")
os.environ.setdefault("QT_QUICK_CONTROLS_HOVER_ENABLED", "1")

# Import Qt modules
from PySide6.QtWidgets import QApplication
from PySide6.QtCore import qInstallMessageHandler, QtMsgType, Qt, QTimer, qVersion
from PySide6.QtGui import QSurfaceFormat

# Import application modules
from src.common import init_logging, log_ui_event
from src.ui.main_window import MainWindow

# Import custom geometry (auto-registered via @QmlElement)
from src.ui.custom_geometry import SphereGeometry, CubeGeometry

# Global references for signal handling
app_instance = None
window_instance = None

def setup_official_surface_format():
    """Setup OpenGL surface format according to Qt Quick 3D 6.9.3 documentation"""
    fmt = QSurfaceFormat()
    
    # Official recommended OpenGL version
    fmt.setVersion(4, 1)  # Minimum for Qt Quick 3D 6.9.3
    fmt.setProfile(QSurfaceFormat.OpenGLContextProfile.CoreProfile)
    
    # Buffer settings for quality rendering
    fmt.setDepthBufferSize(24)
    fmt.setStencilBufferSize(8)
    fmt.setSamples(4)  # 4x MSAA - good balance
    
    # Swap behavior
    fmt.setSwapBehavior(QSurfaceFormat.SwapBehavior.DoubleBuffer)
    fmt.setSwapInterval(1)  # VSync enabled
    
    QSurfaceFormat.setDefaultFormat(fmt)
    
    print(f"🎮 OpenGL Surface Format (Official Qt Quick 3D 6.9.3):")
    print(f"   Version: {fmt.majorVersion()}.{fmt.minorVersion()}")
    print(f"   MSAA: {fmt.samples()}x samples")
    print(f"   Depth: {fmt.depthBufferSize()}bit")
    print(f"   Stencil: {fmt.stencilBufferSize()}bit")

def signal_handler(signum, frame):
    """Graceful shutdown handler"""
    global app_instance, window_instance
    
    print(f"\n🛑 Signal {signum} received, shutting down gracefully...")
    
    if window_instance:
        print("   Closing main window...")
        window_instance.close()
    
    if app_instance:
        print("   Stopping Qt event loop...")
        app_instance.quit()
    
    print("✅ Application shutdown complete")

def qt_message_handler(mode, context, message):
    """Qt message handler with filtering for cleaner output"""
    logger = logging.getLogger("Qt")
    
    # Show important Qt Quick 3D messages
    if any(keyword in message.lower() for keyword in 
           ["rhi:", "quick3d", "custom sphere", "geometry"]):
        print(f"🔍 Qt3D: {message}")
    elif mode == QtMsgType.QtDebugMsg:
        if "js:" in message.lower():
            print(f"🔍 QML: {message}")
    elif mode == QtMsgType.QtWarningMsg:
        # Filter out common deprecation warnings
        if not any(skip in message.lower() for skip in 
                  ["deprecated", "qml connections"]):
            print(f"⚠️ Warning: {message}")
        logger.warning(message)
    elif mode == QtMsgType.QtCriticalMsg:
        print(f"❌ Critical: {message}")
        logger.error(message)
    elif mode == QtMsgType.QtFatalMsg:
        print(f"💀 Fatal: {message}")
        logger.critical(message)
    elif mode == QtMsgType.QtInfoMsg:
        if any(keyword in message.lower() for keyword in 
               ["backend", "rhi", "device", "version"]):
            print(f"ℹ️ Info: {message}")

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="PneumoStabSim - Official Qt Quick 3D 6.9.3 Edition",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python app.py                    # Run with auto-detected optimal RHI
  python app.py --no-block         # Non-blocking mode
  python app.py --test-mode        # Test mode (auto-close after 5s)
  python app.py --legacy           # Use legacy OpenGL instead of Qt Quick 3D
  python app.py --rhi vulkan       # Force Vulkan RHI backend
  python app.py --rhi d3d12        # Force DirectX 12 RHI backend
  python app.py --debug            # Enable debug output
  python app.py --performance      # Performance optimization mode
        """
    )
    
    parser.add_argument('--no-block', action='store_true',
                       help='Non-blocking mode')
    parser.add_argument('--test-mode', action='store_true',
                       help='Test mode (auto-close after 5 seconds)')
    parser.add_argument('--legacy', action='store_true',
                       help='Use legacy OpenGL instead of Qt Quick 3D')
    parser.add_argument('--rhi', 
                       choices=['auto', 'd3d11', 'd3d12', 'vulkan', 'metal', 'opengl'],
                       default='auto',
                       help='Force specific RHI backend')
    parser.add_argument('--debug', action='store_true',
                       help='Enable debug output')
    parser.add_argument('--performance', action='store_true',
                       help='Performance optimization mode')
    
    return parser.parse_args()

def main():
    """Main application function using official Qt Quick 3D 6.9.3"""
    global app_instance, window_instance
    
    # Parse arguments
    args = parse_arguments()
    
    # Setup surface format before QApplication
    setup_official_surface_format()
    
    # Override RHI if requested
    selected_backend = optimal_backend
    if args.rhi != 'auto':
        os.environ["QSG_RHI_BACKEND"] = args.rhi
        selected_backend = args.rhi
        print(f"🔧 RHI backend forced to: {args.rhi}")
    
    # Performance optimizations
    if args.performance:
        if sys.platform == 'win32':
            os.environ["QSG_RENDER_LOOP"] = "windows"
        os.environ["QT_OPENGL_NO_SANITY_CHECK"] = "1"
        print("🚀 Performance optimization enabled")
    
    # Initialize logging
    logger = init_logging("PneumoStabSim", Path("logs"))
    logger.info("Official Qt Quick 3D 6.9.3 application starting...")
    
    # Determine rendering backend
    use_qml_3d = USE_QML_3D_SCHEMA and not args.legacy
    backend_description = f"Official Qt Quick 3D 6.9.3 ({selected_backend.upper()})" if use_qml_3d else "Legacy OpenGL"
    
    print("=" * 70)
    print("🚀 PNEUMOSTABSIM - OFFICIAL QT QUICK 3D 6.9.3")
    print("=" * 70)
    print(f"🎮 Rendering: {backend_description}")
    print(f"🔧 RHI Backend: {selected_backend.upper()}")
    print(f"📦 Qt Version: {qVersion()}")
    print(f"🐍 Python Version: {sys.version.split()[0]}")
    
    if use_qml_3d:
        print("🌟 Official Features Enabled:")
        print("   ✨ HDR Rendering Pipeline")
        print("   🔥 Post-Processing Effects (Bloom, Chromatic Aberration)")
        print("   💎 PBR Materials (Metal, Glass, Emission)")
        print("   ⚡ Hardware Shadows & Anti-aliasing")
        print("   🎯 Advanced Camera Controls")
        print("   📊 Real-time Performance Monitoring")
    
    if args.no_block:
        print("🔓 Mode: Non-blocking")
    elif args.test_mode:
        print("🧪 Mode: Test (5s auto-close)")
    else:
        print("🔒 Mode: Standard blocking")
    
    print("=" * 70)
    print()
    
    # Configure high DPI
    QApplication.setHighDpiScaleFactorRoundingPolicy(
        Qt.HighDpiScaleFactorRoundingPolicy.PassThrough
    )
    
    print("Step 1: Creating QApplication...")
    
    # Create Qt application
    app = QApplication(sys.argv)
    app.setApplicationName("PneumoStabSim")
    app.setApplicationVersion("6.9.3")  # Match Qt Quick 3D version
    app.setOrganizationName("PneumoStabSim")
    app.setApplicationDisplayName("Official Qt Quick 3D 6.9.3 Pneumatic Stabilizer")
    
    # Set application attributes (avoid deprecated ones)
    app.setAttribute(Qt.ApplicationAttribute.AA_UseHighDpiPixmaps, True)
    
    app_instance = app
    
    print("Step 2: Installing message handler...")
    qInstallMessageHandler(qt_message_handler)
    
    log_ui_event("APP_CREATED", f"Qt application created ({backend_description})")
    
    print("Step 3: Registering QML types...")
    print("  🔸 SphereGeometry (auto-registered)")
    print("  🔸 CubeGeometry (auto-registered)")
    print("  🔸 Official Qt Quick 3D materials")
    print("  🔸 Post-processing effects")
    
    print(f"Step 4: Creating MainWindow...")
    print(f"         Backend: {backend_description}")
    print(f"         Effects: HDR + Bloom + Shadows")
    
    try:
        # Create main window
        window = MainWindow(use_qml_3d=use_qml_3d)
        window_instance = window
        
        print(f"Step 5: MainWindow created successfully")
        print(f"         Size: {window.size().width()}×{window.size().height()}")
        
        # Show window
        window.show()
        
        print(f"Step 6: Window displayed")
        print(f"         Position: ({window.pos().x()}, {window.pos().y()})")
        
        # Bring to foreground
        window.raise_()
        window.activateWindow()
        
        log_ui_event("WINDOW_SHOWN", f"Main window displayed ({backend_description})")
        
        print("\n" + "🌟" * 70)
        print(f"APPLICATION READY - {backend_description}")
        print("🌟" * 70)
        
        if use_qml_3d:
            print("✨ OFFICIAL QT QUICK 3D 6.9.3 FEATURES:")
            print("  🔸 HDR Rendering: Extended dynamic range")
            print("  🔸 Post-Processing: Bloom + Chromatic Aberration + Tonemapping") 
            print("  🔸 PBR Materials: Physically accurate metallic/glass surfaces")
            print("  🔸 Advanced Lighting: IBL + Dynamic shadows")
            print("  🔸 Multi-harmonic Physics: Realistic suspension animation")
            print("  🔸 Performance Monitoring: Real-time FPS display")
            print()
            print("🎮 CONTROLS:")
            print("  🖱️  Left Mouse + Drag: Rotate camera")
            print("  🖱️  Mouse Wheel: Zoom in/out")  
            print("  ⌨️  R: Reset camera position")
            print("  🖱️  Click overlay: Pause/Resume animation")
            print("  🖱️  Scroll on overlay: Adjust speed")
            print()
            print("🏗️ SIMULATION:")
            print("  🔩 4-corner pneumatic suspension")
            print("  🔧 Realistic chrome and glass materials")
            print("  💨 Physics-based piston animation")
            print("  ⚙️ Multi-frequency vibration simulation")
        else:
            print("⚙️ Legacy OpenGL rendering")
        
        print()
        print("🔍 DIAGNOSTIC INFO:")
        print(f"  Look for 'rhi: backend: {selected_backend}' in console")
        print("  Expected: Russian UI labels throughout interface")
        print("  Performance overlay in top-right corner")
        
        print("🌟" * 70 + "\n")
        
        # Setup signal handlers
        signal.signal(signal.SIGINT, signal_handler)
        if hasattr(signal, 'SIGTERM'):
            signal.signal(signal.SIGTERM, signal_handler)
        
        # Test mode auto-close
        if args.test_mode:
            close_timer = QTimer()
            close_timer.setSingleShot(True)
            close_timer.timeout.connect(lambda: [
                print("🧪 Test mode: Auto-closing..."),
                window.close()
            ])
            close_timer.start(5000)
        
        # Non-blocking mode
        if args.no_block:
            print("🔓 Starting in non-blocking mode...")
            
            try:
                # Allow window to initialize
                start_time = time.time()
                while time.time() - start_time < 2.5:
                    app.processEvents()
                    time.sleep(0.016)  # ~60 FPS
                
                print("✅ Application initialized and running")
                print("    Window should be visible and interactive")
                print("    Script will now exit, but window remains open")
                
                return 0
                
            except KeyboardInterrupt:
                print("\n🛑 Ctrl+C received, switching to standard mode...")
        
        # Standard blocking mode
        print("🔒 Starting Qt event loop...")
        result = app.exec()
        
        logger.info(f"Application finished with exit code: {result}")
        print(f"\n=== APPLICATION CLOSED (exit code: {result}) ===")
        return result
        
    except Exception as e:
        logger.critical(f"Fatal application error: {e}")
        import traceback
        logger.critical(traceback.format_exc())
        print(f"\n💀 FATAL ERROR: {e}")
        traceback.print_exc()
        return 1
    
    finally:
        # Logging cleanup handled automatically
        pass

if __name__ == "__main__":
    sys.exit(main())
