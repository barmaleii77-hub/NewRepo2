import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

// ===============================
// COMPATIBLE QT QUICK 3D MAIN VIEW FOR 6.9.3 - ИСПРАВЛЕНА ИНТЕГРАЦИЯ С PYTHON
// ===============================
View3D {
    id: view3d
    anchors.fill: parent
    
    // === DYNAMIC PROPERTIES FROM PYTHON ===
    property real userFrameLength: 3200.0
    property real userFrameHeight: 650.0  
    property real userBeamSize: 120.0
    property real userLeverLength: 800.0
    property real userBoreHead: 80.0
    property real userRodDiameter: 35.0
    property real userStroke: 300.0
    property real userPistonRodLength: 200.0
    property real rodPosition: 0.6
    
    // ✨ НОВОЕ: Параметры анимации от Python (ModesPanel)
    property real userAmplitude: 8.0        // градусы (конвертированные из метров)
    property real userFrequency: 1.0        // Гц
    property real userPhaseGlobal: 0.0      // градусы
    property real userPhaseFL: 0.0          // градусы для переднего левого
    property real userPhaseFR: 0.0          // градусы для переднего правого  
    property real userPhaseRL: 0.0          // градусы для заднего левого
    property real userPhaseRR: 0.0          // градусы для заднего правого
    
    // ✨ НОВОЕ: Контроль анимации от Python
    property bool isRunning: true           // управляется из MainWindow
    
    // ✨ НОВОЕ: Позиции поршней от физики (мм от начала цилиндра)
    property real userPistonPositionFL: 125.0
    property real userPistonPositionFR: 125.0
    property real userPistonPositionRL: 125.0
    property real userPistonPositionRR: 125.0
    
    // === ANIMATION SYSTEM ===
    property real animationTime: 0.0
    property real animationSpeed: 1.0
    
    Timer {
        id: animationTimer
        running: isRunning  // ✨ ИСПРАВЛЕНО: управляется из Python
        interval: 16  // 60 FPS
        repeat: true
        
        property int frameCount: 0
        property real lastTime: Date.now()
        property real fps: 60.0
        
        onTriggered: {
            animationTime += animationSpeed * 0.016
            
            // FPS calculation
            frameCount++
            var now = Date.now()
            if (now - lastTime > 1000) {
                fps = frameCount * 1000 / (now - lastTime)
                frameCount = 0
                lastTime = now
            }
        }
    }
    
    // ✨ НОВОЕ: Функция обновления геометрии (вызывается из Python)
    function updateGeometry(params) {
        console.log("🔧 QML updateGeometry() вызвана с параметрами:", JSON.stringify(params))
        
        if (params.frameLength !== undefined) {
            userFrameLength = params.frameLength
            console.log("  📐 frameLength =", userFrameLength)
        }
        if (params.frameHeight !== undefined) {
            userFrameHeight = params.frameHeight
        }
        if (params.frameBeamSize !== undefined) {
            userBeamSize = params.frameBeamSize  
        }
        if (params.leverLength !== undefined) {
            userLeverLength = params.leverLength
        }
        if (params.cylinderBodyLength !== undefined) {
            userStroke = params.cylinderBodyLength
        }
        if (params.boreHead !== undefined) {
            userBoreHead = params.boreHead
        }
        if (params.rodDiameter !== undefined) {
            userRodDiameter = params.rodDiameter
        }
        if (params.rodPosition !== undefined) {
            rodPosition = params.rodPosition
            console.log("  🎯 КРИТИЧЕСКИЙ: rodPosition =", rodPosition)
        }
        
        console.log("✅ Геометрия обновлена в QML")
    }
    
    // ✨ НОВОЕ: Функция обновления позиций поршней (от реальной физики)
    function updatePistonPositions(positions) {
        console.log("🔧 QML updatePistonPositions() вызвана:", JSON.stringify(positions))
        
        if (positions.fl !== undefined) {
            userPistonPositionFL = positions.fl
        }
        if (positions.fr !== undefined) {
            userPistonPositionFR = positions.fr
        }
        if (positions.rl !== undefined) {
            userPistonPositionRL = positions.rl
        }
        if (positions.rr !== undefined) {
            userPistonPositionRR = positions.rr
        }
        
        console.log("✅ Позиции поршней обновлены в QML")
    }
    
    // === ADVANCED CAMERA ===
    camera: advancedCamera
    
    PerspectiveCamera {
        id: advancedCamera
        position: Qt.vector3d(0, 500, 2500)
        eulerRotation: Qt.vector3d(-12, 0, 0)
        fieldOfView: 45
        clipNear: 1.0
        clipFar: 20000.0
        
        // Smooth camera transitions
        Behavior on position { 
            Vector3dAnimation { 
                duration: 1000
                easing.type: Easing.OutCubic 
            } 
        }
        
        Behavior on eulerRotation { 
            Vector3dAnimation { 
                duration: 800
                easing.type: Easing.OutQuart 
            } 
        }
    }
    
    // === ADVANCED ENVIRONMENT ===
    environment: SceneEnvironment {
        id: environment
        backgroundMode: SceneEnvironment.Color
        clearColor: "#1a1a2e"
        
        // Anti-aliasing (compatible with 6.9.3)
        antialiasingMode: SceneEnvironment.MSAA
        antialiasingQuality: SceneEnvironment.High
        
        // Light probe for reflections
        lightProbe: hdrProbe
        probeExposure: 1.2
        probeHorizon: -0.1
    }
    
    // === HDR ENVIRONMENT PROBE ===
    Texture {
        id: hdrProbe
        source: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="
        mappingMode: Texture.LightProbe
        tilingModeHorizontal: Texture.Repeat
        tilingModeVertical: Texture.Repeat
    }
    
    // === ADVANCED LIGHTING SYSTEM ===
    
    // Main sun light
    DirectionalLight {
        id: sunLight
        eulerRotation.x: -25
        eulerRotation.y: -35
        brightness: 2.5
        castsShadow: true
        shadowMapQuality: Light.ShadowMapQualityHigh
        shadowMapFar: 8000
        shadowBias: -0.0008
        shadowFactor: 50
        color: "#fff8e1"
        
        // Dynamic brightness
        SequentialAnimation on brightness {
            running: isRunning
            loops: Animation.Infinite
            NumberAnimation { to: 3.0; duration: 4000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 2.0; duration: 4000; easing.type: Easing.InOutSine }
        }
    }
    
    // Fill light
    DirectionalLight {
        eulerRotation.x: 20
        eulerRotation.y: 135
        brightness: 0.4
        color: "#e1f5fe"
        castsShadow: false
    }
    
    // Accent point lights
    Repeater {
        model: [
            { pos: Qt.vector3d(-2000, 1000, -1500), color: "#ff6b35", brightness: 150 },
            { pos: Qt.vector3d(2000, 1000, 1500), color: "#4fc3f7", brightness: 120 },
            { pos: Qt.vector3d(0, 2000, 0), color: "#fff59d", brightness: 80 }
        ]
        
        PointLight {
            position: modelData.pos
            color: modelData.color
            brightness: modelData.brightness
            castsShadow: false
            
            // Animated intensity
            SequentialAnimation on brightness {
                running: isRunning
                loops: Animation.Infinite
                NumberAnimation { 
                    to: modelData.brightness * 1.3
                    duration: 2000 + index * 500
                    easing.type: Easing.InOutQuad 
                }
                NumberAnimation { 
                    to: modelData.brightness * 0.7
                    duration: 2000 + index * 500
                    easing.type: Easing.InOutQuad 
                }
            }
        }
    }
    
    // === PREMIUM MATERIALS ===
    
    // Ultra-premium chrome for main components
    PrincipledMaterial {
        id: ultraChrome
        baseColor: "#f8f9fa"
        metalness: 0.98
        roughness: 0.02
        specularAmount: 1.0
        indexOfRefraction: 3.2
        normalStrength: 1.5
    }
    
    // Premium anodized frame material
    PrincipledMaterial {
        id: premiumFrame
        baseColor: "#c62828"
        metalness: 0.95
        roughness: 0.12
        specularAmount: 1.0
        indexOfRefraction: 2.8
        normalStrength: 1.2
    }
    
    // Advanced glass for cylinders
    PrincipledMaterial {
        id: advancedGlass
        baseColor: Qt.rgba(0.9, 0.95, 1.0, 0.12)
        metalness: 0.0
        roughness: 0.01
        opacity: 0.12
        alphaMode: PrincipledMaterial.Blend
        specularAmount: 1.0
        indexOfRefraction: 1.52
        transmissionFactor: 0.95
        thicknessFactor: 0.08
    }
    
    // Joint positions (dynamic based on parameters)
    property vector3d fl_j_arm: Qt.vector3d(-userBeamSize/2 - 30, userBeamSize + 40, -userFrameLength/2 + 200)
    property vector3d fr_j_arm: Qt.vector3d(userBeamSize/2 + 30, userBeamSize + 40, -userFrameLength/2 + 200)
    property vector3d rl_j_arm: Qt.vector3d(-userBeamSize/2 - 30, userBeamSize + 40, userFrameLength/2 - 200)
    property vector3d rr_j_arm: Qt.vector3d(userBeamSize/2 + 30, userBeamSize + 40, userFrameLength/2 - 200)
    
    property vector3d fl_j_tail: Qt.vector3d(fl_j_arm.x + 50, fl_j_arm.y + userFrameHeight - 50, fl_j_arm.z)
    property vector3d fr_j_tail: Qt.vector3d(fr_j_arm.x - 50, fr_j_arm.y + userFrameHeight - 50, fr_j_arm.z)
    property vector3d rl_j_tail: Qt.vector3d(rl_j_arm.x + 50, rl_j_arm.y + userFrameHeight - 50, rl_j_arm.z)
    property vector3d rr_j_tail: Qt.vector3d(rr_j_arm.x - 50, rr_j_arm.y + userFrameHeight - 50, rr_j_arm.z)
    
    // Rod positions (calculated from lever angles)
    property vector3d fl_j_rod: Qt.vector3d(
        fl_j_arm.x + userLeverLength * Math.cos((180 + fl_angle) * Math.PI / 180),
        fl_j_arm.y + userLeverLength * Math.sin((180 + fl_angle) * Math.PI / 180),
        fl_j_arm.z
    )
    property vector3d fr_j_rod: Qt.vector3d(
        fr_j_arm.x + userLeverLength * Math.cos((0 + fr_angle) * Math.PI / 180),
        fr_j_arm.y + userLeverLength * Math.sin((0 + fr_angle) * Math.PI / 180),
        fr_j_arm.z
    )
    property vector3d rl_j_rod: Qt.vector3d(
        rl_j_arm.x + userLeverLength * Math.cos((180 + rl_angle) * Math.PI / 180),
        rl_j_arm.y + userLeverLength * Math.sin((180 + rl_angle) * Math.PI / 180),
        rl_j_arm.z
    )
    property vector3d rr_j_rod: Qt.vector3d(
        rr_j_arm.x + userLeverLength * Math.cos((0 + rr_angle) * Math.PI / 180),
        rr_j_arm.y + userLeverLength * Math.sin((0 + rr_angle) * Math.PI / 180),
        rr_j_arm.z
    )
    
    // === MAIN FRAME WITH PREMIUM MATERIALS ===
    
    // Main longitudinal beam with premium effects
    Model {
        source: "#Cube"
        position: Qt.vector3d(0, userBeamSize/2, 0)
        scale: Qt.vector3d(userBeamSize/100, userBeamSize/100, userFrameLength/100)
        materials: premiumFrame
        
        // Smooth parameter updates
        Behavior on scale { 
            Vector3dAnimation { duration: 800; easing.type: Easing.OutCubic } 
        }
    }
    
    // Side frames with staggered animations
    Repeater {
        model: [
            { z: -userFrameLength/2, delay: 0 },
            { z: userFrameLength/2, delay: 1000 }
        ]
        
        Model {
            source: "#Cube"
            position: Qt.vector3d(0, userBeamSize + userFrameHeight/2, modelData.z)
            scale: Qt.vector3d(userBeamSize/100, userFrameHeight/100, userBeamSize/100)
            materials: premiumFrame
            
            Behavior on scale { 
                Vector3dAnimation { duration: 800; easing.type: Easing.OutCubic } 
            }
        }
    }
    
    // === ADVANCED SUSPENSION CORNERS ===
    component AdvancedSuspensionCorner: Node {
        id: suspensionNode
        
        required property vector3d j_arm
        required property vector3d j_tail  
        required property vector3d j_rod
        required property real leverAngle
        required property bool isLeft
        required property real pistonPositionMm  // ✨ НОВОЕ: позиция от физики
        
        // Calculated properties
        property real baseAngle: isLeft ? 180 : 0
        property real totalAngle: baseAngle + leverAngle
        
        // Cylinder geometry calculations
        property vector3d cylDirection: Qt.vector3d(j_rod.x - j_tail.x, j_rod.y - j_tail.y, 0)
        property real cylDirectionLength: Math.hypot(cylDirection.x, cylDirection.y)
        property real lBody: userStroke
        property real lTailRod: 100
        
        property vector3d tailRodEnd: Qt.vector3d(
            j_tail.x + cylDirection.x * (lTailRod / cylDirectionLength),
            j_tail.y + cylDirection.y * (lTailRod / cylDirectionLength),
            j_tail.z
        )
        
        property vector3d cylStart: tailRodEnd
        property vector3d cylEnd: Qt.vector3d(
            cylStart.x + cylDirection.x * (lBody / cylDirectionLength),
            cylStart.y + cylDirection.y * (lBody / cylDirectionLength),
            cylStart.z
        )
        
        // ✨ ИСПРАВЛЕНО: Piston position from physics (not animation!)
        property real pistonRatio: pistonPositionMm / lBody  // Используем реальную позицию
        property vector3d pistonCenter: Qt.vector3d(
            cylStart.x + cylDirection.x * ((lBody * pistonRatio) / cylDirectionLength),
            cylStart.y + cylDirection.y * ((lBody * pistonRatio) / cylDirectionLength),
            cylStart.z
        )
        
        // === PREMIUM LEVER ===
        Model {
            source: "#Cube"
            position: Qt.vector3d(
                j_arm.x + (userLeverLength/2) * Math.cos(totalAngle * Math.PI / 180), 
                j_arm.y + (userLeverLength/2) * Math.sin(totalAngle * Math.PI / 180), 
                j_arm.z
            )
            scale: Qt.vector3d(userLeverLength/100, 1.2, 1.8)
            eulerRotation: Qt.vector3d(0, 0, totalAngle)
            materials: ultraChrome
            
            // Smooth lever movement
            Behavior on eulerRotation.z {
                NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
            }
        }
        
        // === ADVANCED GLASS CYLINDER ===
        Model {
            source: "#Cylinder"
            position: Qt.vector3d((cylStart.x + cylEnd.x)/2, (cylStart.y + cylEnd.y)/2, cylStart.z)
            scale: Qt.vector3d(userBoreHead/100, lBody/100, userBoreHead/100)
            eulerRotation: Qt.vector3d(0, 0, Math.atan2(cylEnd.y - cylStart.y, cylEnd.x - cylStart.x) * 180 / Math.PI + 90)
            materials: advancedGlass
            
            // Smooth position updates
            Behavior on position {
                Vector3dAnimation { duration: 200; easing.type: Easing.OutQuart }
            }
        }
        
        // === ANIMATED PREMIUM PISTON ===
        Model {
            source: "#Cylinder"
            position: pistonCenter
            scale: Qt.vector3d((userBoreHead-4)/100, 0.4, (userBoreHead-4)/100)
            eulerRotation: Qt.vector3d(0, 0, Math.atan2(cylDirection.y, cylDirection.x) * 180 / Math.PI + 90)
            
            materials: PrincipledMaterial {
                baseColor: "#e91e63"
                metalness: 0.92
                roughness: 0.08
                specularAmount: 1.0
                indexOfRefraction: 2.5
            }
            
            // Physics-based piston movement
            Behavior on position {
                Vector3dAnimation { 
                    duration: 80 
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.2
                }
            }
        }
        
        // === DYNAMIC PISTON ROD ===
        Model {
            source: "#Cylinder"
            
            property real rodLength: Math.hypot(j_rod.x - pistonCenter.x, j_rod.y - pistonCenter.y)
            
            position: Qt.vector3d(
                (pistonCenter.x + j_rod.x)/2, 
                (pistonCenter.y + j_rod.y)/2, 
                pistonCenter.z
            )
            scale: Qt.vector3d(userRodDiameter/100, rodLength/100, userRodDiameter/100)
            eulerRotation: Qt.vector3d(0, 0, Math.atan2(j_rod.y - pistonCenter.y, j_rod.x - pistonCenter.x) * 180 / Math.PI + 90)
            
            materials: PrincipledMaterial {
                baseColor: "#eceff1"
                metalness: 0.98
                roughness: 0.02
                specularAmount: 1.0
                indexOfRefraction: 3.5
            }
        }
        
        // === TAIL ROD ===
        Model {
            source: "#Cylinder"
            position: Qt.vector3d((j_tail.x + tailRodEnd.x)/2, (j_tail.y + tailRodEnd.y)/2, j_tail.z)
            scale: Qt.vector3d(userRodDiameter/100, lTailRod/100, userRodDiameter/100)
            eulerRotation: Qt.vector3d(0, 0, Math.atan2(tailRodEnd.y - j_tail.y, tailRodEnd.x - j_tail.x) * 180 / Math.PI + 90)
            materials: ultraChrome
        }
        
        // === PREMIUM JOINTS ===
        Repeater {
            model: [
                { pos: j_tail, color: "#1565c0", size: 2.0, name: "tail" },
                { pos: j_arm, color: "#ef6c00", size: 1.8, name: "arm" },
                { pos: j_rod, color: "#2e7d32", size: 1.5, name: "rod" }
            ]
            
            Model {
                source: "#Sphere"
                position: modelData.pos
                scale: Qt.vector3d(modelData.size, modelData.size, modelData.size)
                
                materials: PrincipledMaterial {
                    baseColor: modelData.color
                    metalness: 0.9
                    roughness: 0.1
                    specularAmount: 1.0
                    indexOfRefraction: 2.2
                }
                
                // Breathing effect
                SequentialAnimation on scale {
                    running: isRunning
                    loops: Animation.Infinite
                    
                    Vector3dAnimation {
                        to: Qt.vector3d(modelData.size * 1.1, modelData.size * 1.1, modelData.size * 1.1)
                        duration: 2000 + index * 500
                        easing.type: Easing.InOutSine
                    }
                    Vector3dAnimation {
                        to: Qt.vector3d(modelData.size, modelData.size, modelData.size)
                        duration: 2000 + index * 500
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }
    }
    
    // === INSTANTIATE ALL FOUR CORNERS ===
    AdvancedSuspensionCorner { 
        j_arm: fl_j_arm; j_tail: fl_j_tail; j_rod: fl_j_rod; leverAngle: fl_angle; isLeft: true
        pistonPositionMm: userPistonPositionFL  // ✨ НОВОЕ: используем реальную позицию
    }
    AdvancedSuspensionCorner { 
        j_arm: fr_j_arm; j_tail: fr_j_tail; j_rod: fr_j_rod; leverAngle: fr_angle; isLeft: false
        pistonPositionMm: userPistonPositionFR
    }
    AdvancedSuspensionCorner { 
        j_arm: rl_j_arm; j_tail: rl_j_tail; j_rod: rl_j_rod; leverAngle: rl_angle; isLeft: true
        pistonPositionMm: userPistonPositionRL
    }
    AdvancedSuspensionCorner { 
        j_arm: rr_j_arm; j_tail: rr_j_tail; j_rod: rr_j_rod; leverAngle: rr_angle; isLeft: false
        pistonPositionMm: userPistonPositionRR
    }
    
    // === SIMPLE CAMERA CONTROL (NO ORBIT CONTROLLER) ===
    // ИСПРАВЛЕНО: Убираем OrbitCameraController чтобы избежать ошибки eulerRotation
    
    // Manual camera rotation
    property real cameraAngle: 0.0
    
    SequentialAnimation {
        id: cameraRotation
        running: isRunning
        loops: Animation.Infinite
        
        NumberAnimation {
            target: view3d
            property: "cameraAngle"
            to: 360
            duration: 25000
            easing.type: Easing.Linear
        }
    }
    
    onCameraAngleChanged: {
        if (advancedCamera) {
            let radius = 2500
            let height = 500
            let x = radius * Math.sin(cameraAngle * Math.PI / 180)
            let z = radius * Math.cos(cameraAngle * Math.PI / 180)
            
            advancedCamera.position = Qt.vector3d(x, height, z)
            
            // Look at center
            let yaw = Math.atan2(-x, -z) * 180 / Math.PI
            advancedCamera.eulerRotation = Qt.vector3d(-12, yaw, 0)
        }
    }
    
    // === MANUAL MOUSE CONTROL ===
    MouseArea {
        anchors.fill: parent
        property real lastX: 0
        property real lastY: 0
        property bool dragging: false
        
        onPressed: function(mouse) {
            lastX = mouse.x
            lastY = mouse.y
            dragging = true
            cameraRotation.running = false  // Stop auto rotation
        }
        
        onReleased: {
            dragging = false
            // Restart auto rotation after 3 seconds
            restartTimer.start()
        }
        
        onPositionChanged: function(mouse) {
            if (dragging && advancedCamera) {
                let deltaX = mouse.x - lastX
                let deltaY = mouse.y - lastY
                
                // Manual camera control
                view3d.cameraAngle += deltaX * 0.5
                
                let currentRotation = advancedCamera.eulerRotation
                let newPitch = Math.max(-60, Math.min(60, currentRotation.x - deltaY * 0.3))
                advancedCamera.eulerRotation = Qt.vector3d(newPitch, currentRotation.y, 0)
                
                lastX = mouse.x
                lastY = mouse.y
            }
        }
        
        onWheel: function(wheel) {
            if (advancedCamera) {
                let currentPos = advancedCamera.position
                let factor = wheel.angleDelta.y > 0 ? 0.9 : 1.1
                let distance = Math.sqrt(currentPos.x * currentPos.x + currentPos.z * currentPos.z)
                let newDistance = Math.max(800, Math.min(5000, distance * factor))
                
                let angle = Math.atan2(currentPos.x, currentPos.z)
                advancedCamera.position = Qt.vector3d(
                    newDistance * Math.sin(angle),
                    currentPos.y,
                    newDistance * Math.cos(angle)
                )
            }
        }
    }
    
    Timer {
        id: restartTimer
        interval: 3000
        onTriggered: {
            cameraRotation.running = isRunning
        }
    }
    
    // === PERFORMANCE MONITORING OVERLAY ===
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        width: 320
        height: 200
        color: Qt.rgba(0, 0, 0, 0.8)
        radius: 12
        border.color: "#4fc3f7"
        border.width: 2
        
        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 8
            
            Text {
                text: "🚀 PneumoStabSim ИСПРАВЛЕНО"
                color: "#00ff00"
                font.bold: true
                font.pixelSize: 14
            }
            
            Text {
                text: `FPS: ${animationTimer.fps.toFixed(1)}`
                color: animationTimer.fps > 50 ? "#4caf50" : "#ff9800"
                font.pixelSize: 14
                font.family: "monospace"
            }
            
            Text {
                text: "✅ Python ↔ QML интеграция"
                color: "#4caf50"
                font.pixelSize: 11
            }
            
            Text {
                text: `🎛️ Амплитуда: ${userAmplitude.toFixed(1)}°`
                color: "#2196f3"
                font.pixelSize: 11
            }
            
            Text {
                text: `📊 Частота: ${userFrequency.toFixed(1)} Гц`
                color: "#ff9800"
                font.pixelSize: 11
            }
            
            Text {
                text: `Animation: ${isRunning ? "▶️ Running" : "⏸️ Stopped"}`
                color: "#9c27b0"
                font.pixelSize: 11
            }
            
            Text {
                text: `🎯 rodPosition: ${rodPosition.toFixed(2)}`
                color: "#e91e63"
                font.pixelSize: 10
            }
        }
        
        // Click to toggle pause
        MouseArea {
            anchors.fill: parent
            onClicked: isRunning = !isRunning
            cursorShape: Qt.PointingHandCursor
        }
    }
    
    // === DEBUG INFO ===
    Component.onCompleted: {
        console.log("🌟 ===============================================")
        console.log("🚀 ИСПРАВЛЕННЫЙ PNEUMATIC SIMULATOR")
        console.log("🌟 ===============================================")
        console.log("✅ Добавлены функции: updateGeometry(), updatePistonPositions()")
        console.log("✅ Добавлены свойства анимации: userAmplitude, userFrequency, userPhase*")
        console.log("✅ Добавлен контроль: isRunning")
        console.log("✅ Добавлены позиции поршней: userPistonPosition*")
        console.log("📐 Frame dimensions:", userFrameLength + "x" + userFrameHeight + "x" + userBeamSize + "mm")
        console.log("🔧 Lever length:", userLeverLength + "mm")  
        console.log("💨 Cylinder stroke:", userStroke + "mm")
        console.log("🎮 Animation: Amplitude=" + userAmplitude + "°, Frequency=" + userFrequency + "Hz")
        console.log("🌟 ===============================================")
        
        view3d.forceActiveFocus()
    }
}
