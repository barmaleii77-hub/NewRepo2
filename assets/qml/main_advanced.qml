import QtQuick
import QtQuick3D
import QtQuick3D.Effects
import QtQuick3D.Helpers

// ADVANCED QT QUICK 3D - ПОЛНОЕ ИСПОЛЬЗОВАНИЕ ВСЕХ ВОЗМОЖНОСТЕЙ
ApplicationWindow {
    id: root
    title: "Advanced Qt Quick 3D - Pneumatic Stabilizer"
    width: 1600
    height: 1000
    
    // === GEOMETRY PARAMETERS FROM PYTHON ===
    property real userFrameLength: 3200.0
    property real userFrameHeight: 650.0
    property real userBeamSize: 120.0
    property real userLeverLength: 800.0
    property real userBoreHead: 80.0
    property real userRodDiameter: 35.0
    property real userStroke: 300.0
    property real userPistonRodLength: 200.0
    property real rodPosition: 0.6
    
    // === ANIMATION SYSTEM ===
    property real animationTime: 0.0
    property bool animationRunning: true
    property real animationSpeed: 1.0
    
    // Advanced animation timer with performance monitoring
    Timer {
        id: animationTimer
        running: animationRunning
        interval: 16  // 60 FPS
        repeat: true
        
        property int frameCount: 0
        property real lastFpsUpdate: 0
        property real currentFps: 60
        
        onTriggered: {
            animationTime += animationSpeed * 0.016
            frameCount++
            
            var now = Date.now()
            if (now - lastFpsUpdate > 1000) {
                currentFps = frameCount
                frameCount = 0
                lastFpsUpdate = now
                fpsDisplay.text = `FPS: ${currentFps}`
            }
        }
    }
    
    View3D {
        id: view3d
        anchors.fill: parent
        
        // === ADVANCED CAMERA SYSTEM ===
        camera: perspectiveCamera
        
        PerspectiveCamera {
            id: perspectiveCamera
            position: Qt.vector3d(0, 400, 2000)
            eulerRotation.x: -15
            fieldOfView: 45
            clipNear: 1.0
            clipFar: 10000.0
            
            // Smooth camera animations
            Behavior on position { 
                Vector3dAnimation { duration: 800; easing.type: Easing.OutCubic } 
            }
            Behavior on eulerRotation { 
                Vector3dAnimation { duration: 600; easing.type: Easing.OutCubic } 
            }
        }
        
        // === ADVANCED SCENE ENVIRONMENT ===
        environment: SceneEnvironment {
            id: sceneEnv
            
            // Advanced background
            backgroundMode: SceneEnvironment.SkyBox
            lightProbe: proceduralSky
            
            // Advanced anti-aliasing
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.VeryHigh
            
            // Post-processing effects
            effects: [
                bloom,
                ssao,
                fxaa
            ]
            
            // Advanced tonemapping
            tonemapMode: SceneEnvironment.TonemapModeFilmic
            
            // Temporal effects
            temporalAAEnabled: true
            temporalAAStrength: 0.5
            
            // Exposure and gamma
            probeExposure: 1.0
        }
        
        // === ADVANCED LIGHTING SYSTEM ===
        
        // Main directional light (sun)
        DirectionalLight {
            id: sunLight
            eulerRotation.x: -30
            eulerRotation.y: -45
            brightness: 2.0
            castsShadow: true
            shadowMapQuality: Light.ShadowMapQualityVeryHigh
            shadowMapFar: 5000
            shadowBias: -0.0005
            color: "#fff8e1"
            
            // Smooth shadow transitions
            Behavior on brightness { NumberAnimation { duration: 1000 } }
        }
        
        // Fill light
        DirectionalLight {
            eulerRotation.x: 45
            eulerRotation.y: 135
            brightness: 0.3
            color: "#e3f2fd"
        }
        
        // Rim light
        PointLight {
            position: Qt.vector3d(-1000, 800, -800)
            brightness: 100
            color: "#fff3e0"
            castsShadow: false
            
            // Animated brightness
            SequentialAnimation on brightness {
                running: animationRunning
                loops: Animation.Infinite
                NumberAnimation { to: 120; duration: 3000; easing.type: Easing.InOutSine }
                NumberAnimation { to: 80; duration: 3000; easing.type: Easing.InOutSine }
            }
        }
        
        // === ADVANCED MATERIALS ===
        
        // Chrome material for metal parts
        PrincipledMaterial {
            id: chromeMaterial
            baseColor: "#f5f5f5"
            metalness: 0.98
            roughness: 0.02
            specularAmount: 1.0
            indexOfRefraction: 3.0
            normalStrength: 1.2
        }
        
        // Anodized aluminum for frame
        PrincipledMaterial {
            id: frameMetalMaterial
            baseColor: "#d32f2f"
            metalness: 0.95
            roughness: 0.15
            specularAmount: 1.0
            normalStrength: 1.0
            
            // Animated emission for premium look
            emissiveFactor: Qt.vector3d(0.02, 0.0, 0.0)
            SequentialAnimation on emissiveFactor {
                running: animationRunning
                loops: Animation.Infinite
                ColorAnimation { 
                    to: Qt.vector3d(0.05, 0.01, 0.01)
                    duration: 2000 
                }
                ColorAnimation { 
                    to: Qt.vector3d(0.02, 0.0, 0.0)
                    duration: 2000 
                }
            }
        }
        
        // Glass material for cylinders
        PrincipledMaterial {
            id: glassMaterial
            baseColor: Qt.rgba(0.9, 0.95, 1.0, 0.15)
            metalness: 0.0
            roughness: 0.01
            opacity: 0.15
            alphaMode: PrincipledMaterial.Blend
            specularAmount: 1.0
            indexOfRefraction: 1.52
            transmissionFactor: 0.9
            thicknessFactor: 0.1
        }
        
        // === PROCEDURAL SKY ===
        Texture {
            id: proceduralSky
            source: "qrc:/qt/qml/QtQuick3D/Effects/maps/skybox_small.hdr"
        }
        
        // === POST-PROCESSING EFFECTS ===
        
        Bloom {
            id: bloom
            bloomIntensity: 0.8
            bloomThreshold: 0.7
        }
        
        SCurveTonemap {
            id: scurve
        }
        
        Fxaa {
            id: fxaa
        }
        
        // === ADVANCED SUSPENSION GEOMETRY ===
        
        // Dynamic lever angles with physics simulation
        property real fl_angle: 12 * Math.sin(animationTime * 0.7) + 3 * Math.sin(animationTime * 2.3)
        property real fr_angle: 12 * Math.sin(animationTime * 0.7 + Math.PI/4) + 3 * Math.sin(animationTime * 2.1)
        property real rl_angle: 12 * Math.sin(animationTime * 0.7 + Math.PI/2) + 3 * Math.sin(animationTime * 1.9)
        property real rr_angle: 12 * Math.sin(animationTime * 0.7 + 3*Math.PI/4) + 3 * Math.sin(animationTime * 2.7)
        
        // === MAIN FRAME ===
        Model {
            source: "#Cube"
            position: Qt.vector3d(0, userBeamSize/2, 0)
            scale: Qt.vector3d(userBeamSize/100, userBeamSize/100, userFrameLength/100)
            materials: frameMetalMaterial
            
            // Smooth scaling animation
            Behavior on scale { 
                Vector3dAnimation { duration: 500; easing.type: Easing.OutQuart }
            }
        }
        
        // Side frames
        Repeater {
            model: [-1, 1]
            
            Model {
                source: "#Cube"
                position: Qt.vector3d(0, userBeamSize + userFrameHeight/2, modelData * userFrameLength/2)
                scale: Qt.vector3d(userBeamSize/100, userFrameHeight/100, userBeamSize/100)
                materials: frameMetalMaterial
                
                Behavior on scale { 
                    Vector3dAnimation { duration: 500; easing.type: Easing.OutQuart }
                }
            }
        }
        
        // === ADVANCED SUSPENSION CORNERS ===
        Repeater {
            model: [
                { name: "FL", pos: Qt.vector3d(-150, 60, -userFrameLength/2), angle: fl_angle },
                { name: "FR", pos: Qt.vector3d(150, 60, -userFrameLength/2), angle: fr_angle },
                { name: "RL", pos: Qt.vector3d(-150, 60, userFrameLength/2), angle: rl_angle },
                { name: "RR", pos: Qt.vector3d(150, 60, userFrameLength/2), angle: rr_angle }
            ]
            
            Node {
                id: cornerNode
                
                property var cornerData: modelData
                property vector3d j_arm: cornerData.pos
                property real leverAngle: cornerData.angle
                property bool isLeft: cornerData.pos.x < 0
                
                // Calculate positions
                property real baseAngle: isLeft ? 180 : 0
                property real totalAngle: baseAngle + leverAngle
                
                property vector3d j_rod: Qt.vector3d(
                    j_arm.x + userLeverLength * Math.cos(totalAngle * Math.PI / 180),
                    j_arm.y + userLeverLength * Math.sin(totalAngle * Math.PI / 180),
                    j_arm.z
                )
                
                property vector3d j_tail: Qt.vector3d(
                    j_arm.x + (isLeft ? 50 : -50), 
                    j_arm.y + 650, 
                    j_arm.z
                )
                
                // === LEVER ARM ===
                Model {
                    source: "#Cube"
                    position: Qt.vector3d(
                        (j_arm.x + j_rod.x) / 2,
                        (j_arm.y + j_rod.y) / 2,
                        j_arm.z
                    )
                    scale: Qt.vector3d(userLeverLength/100, 0.8, 1.2)
                    eulerRotation.z: totalAngle
                    materials: chromeMaterial
                    
                    // Smooth rotation
                    Behavior on eulerRotation.z {
                        NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                    }
                }
                
                // === CYLINDER BODY ===
                Model {
                    id: cylinderBody
                    source: "#Cylinder"
                    
                    property vector3d direction: Qt.vector3d(j_rod.x - j_tail.x, j_rod.y - j_tail.y, 0)
                    property real dirLength: Math.hypot(direction.x, direction.y)
                    property real cylLength: userStroke + 50  // Base + stroke
                    
                    property vector3d start: Qt.vector3d(
                        j_tail.x + direction.x * (50 / dirLength),
                        j_tail.y + direction.y * (50 / dirLength),
                        j_tail.z
                    )
                    property vector3d end: Qt.vector3d(
                        start.x + direction.x * (cylLength / dirLength),
                        start.y + direction.y * (cylLength / dirLength),
                        start.z
                    )
                    
                    position: Qt.vector3d((start.x + end.x)/2, (start.y + end.y)/2, start.z)
                    scale: Qt.vector3d(userBoreHead/100, cylLength/100, userBoreHead/100)
                    eulerRotation.z: Math.atan2(direction.y, direction.x) * 180 / Math.PI + 90
                    
                    materials: glassMaterial
                    
                    // Smooth position updates
                    Behavior on position {
                        Vector3dAnimation { duration: 150; easing.type: Easing.OutQuad }
                    }
                }
                
                // === ANIMATED PISTON ===
                Model {
                    source: "#Cylinder"
                    
                    property vector3d direction: Qt.vector3d(j_rod.x - j_tail.x, j_rod.y - j_tail.y, 0)
                    property real dirLength: Math.hypot(direction.x, direction.y)
                    property real pistonPos: 0.2 + (leverAngle + 15) / 30 * 0.6  // Normalized position
                    property real cylLength: userStroke + 50
                    
                    property vector3d start: Qt.vector3d(
                        j_tail.x + direction.x * (50 / dirLength),
                        j_tail.y + direction.y * (50 / dirLength),
                        j_tail.z
                    )
                    
                    property vector3d pistonCenter: Qt.vector3d(
                        start.x + direction.x * (cylLength * pistonPos / dirLength),
                        start.y + direction.y * (cylLength * pistonPos / dirLength),
                        start.z
                    )
                    
                    position: pistonCenter
                    scale: Qt.vector3d((userBoreHead-2)/100, 0.3, (userBoreHead-2)/100)
                    eulerRotation.z: Math.atan2(direction.y, direction.x) * 180 / Math.PI + 90
                    
                    materials: PrincipledMaterial {
                        baseColor: "#ff4444"
                        metalness: 0.8
                        roughness: 0.2
                        emissiveFactor: Qt.vector3d(0.1, 0.0, 0.0)
                    }
                    
                    // Smooth piston movement
                    Behavior on position {
                        Vector3dAnimation { duration: 100; easing.type: Easing.OutCubic }
                    }
                }
                
                // === JOINTS ===
                Repeater {
                    model: [
                        { pos: j_arm, color: "#ffaa00", size: 1.5 },
                        { pos: j_tail, color: "#0088ff", size: 1.8 },
                        { pos: j_rod, color: "#00ff44", size: 1.2 }
                    ]
                    
                    Model {
                        source: "#Sphere"
                        position: modelData.pos
                        scale: Qt.vector3d(modelData.size, modelData.size, modelData.size)
                        materials: PrincipledMaterial {
                            baseColor: modelData.color
                            metalness: 0.9
                            roughness: 0.1
                            emissiveFactor: Qt.vector3d(0.05, 0.05, 0.05)
                        }
                    }
                }
            }
        }
        
        // === CAMERA CONTROLS ===
        OrbitCameraController {
            camera: perspectiveCamera
            origin: Qt.vector3d(0, 200, 0)
            panEnabled: true
            xInvert: false
            yInvert: false
        }
    }
    
    // === UI OVERLAY ===
    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 10
        
        Rectangle {
            width: 300
            height: 150
            color: Qt.rgba(0, 0, 0, 0.7)
            radius: 10
            
            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 5
                
                Text {
                    text: "🚀 Advanced Qt Quick 3D"
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 16
                }
                
                Text {
                    id: fpsDisplay
                    text: "FPS: 60"
                    color: "#4caf50"
                    font.pixelSize: 14
                }
                
                Text {
                    text: `Backend: ${sceneEnv.rhi}`
                    color: "#2196f3"
                    font.pixelSize: 12
                }
                
                Text {
                    text: "Features: PBR + Bloom + SSAO"
                    color: "#ff9800"
                    font.pixelSize: 12
                }
                
                Text {
                    text: "🎮 LMB: Rotate, Wheel: Zoom"
                    color: "#9e9e9e"
                    font.pixelSize: 11
                }
            }
        }
        
        // Performance controls
        Rectangle {
            width: 300
            height: 100
            color: Qt.rgba(0, 0, 0, 0.7)
            radius: 10
            
            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                Row {
                    spacing: 15
                    
                    Button {
                        text: animationRunning ? "⏸️ Pause" : "▶️ Play"
                        onClicked: animationRunning = !animationRunning
                    }
                    
                    Button {
                        text: "🔄 Reset"
                        onClicked: {
                            perspectiveCamera.position = Qt.vector3d(0, 400, 2000)
                            perspectiveCamera.eulerRotation.x = -15
                            perspectiveCamera.eulerRotation.y = 0
                            perspectiveCamera.eulerRotation.z = 0
                        }
                    }
                }
                
                Slider {
                    width: 250
                    from: 0.1
                    to: 3.0
                    value: animationSpeed
                    onValueChanged: animationSpeed = value
                    
                    Rectangle {
                        anchors.bottom: parent.top
                        anchors.bottomMargin: 5
                        width: parent.width
                        height: 20
                        color: "transparent"
                        
                        Text {
                            text: `Speed: ${animationSpeed.toFixed(1)}x`
                            color: "#ffffff"
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }
    }
}
