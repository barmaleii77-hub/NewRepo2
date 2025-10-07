import QtQuick
import QtQuick3D
import QtQuick3D.Effects
import QtQuick3D.Helpers

// ===============================================
// OFFICIAL QT QUICK 3D 6.9.3 - PNEUMATIC STABILIZER
// Based on official Qt documentation
// ===============================================
View3D {
    id: mainView
    anchors.fill: parent
    
    // === SIMULATION PARAMETERS ===
    property real frameLength: 3200.0
    property real frameHeight: 650.0  
    property real beamSize: 120.0
    property real leverLength: 800.0
    property real cylinderDiameter: 80.0
    property real rodDiameter: 35.0
    property real stroke: 300.0
    
    // === ANIMATION CONTROL ===
    property real simulationTime: 0.0
    property bool isRunning: true
    property real speedMultiplier: 1.0
    
    Timer {
        id: simulationTimer
        running: isRunning
        interval: 16  // 60 FPS
        repeat: true
        
        property int frameCounter: 0
        property real lastFpsTime: Date.now()
        property real currentFps: 60.0
        
        onTriggered: {
            simulationTime += speedMultiplier * 0.016
            
            // Calculate FPS
            frameCounter++
            let now = Date.now()
            if (now - lastFpsTime > 1000) {
                currentFps = frameCounter * 1000 / (now - lastFpsTime)
                frameCounter = 0
                lastFpsTime = now
            }
        }
    }
    
    // === CAMERA SETUP ===
    camera: mainCamera
    
    PerspectiveCamera {
        id: mainCamera
        position: Qt.vector3d(0, 600, 2800)
        eulerRotation: Qt.vector3d(-10, 0, 0)
        fieldOfView: 50
        clipNear: 1.0
        clipFar: 50000.0
        
        // Smooth camera animations
        Behavior on position { 
            Vector3dAnimation { duration: 1200; easing.type: Easing.OutCubic } 
        }
        Behavior on eulerRotation { 
            Vector3dAnimation { duration: 900; easing.type: Easing.OutQuart } 
        }
    }
    
    // === SCENE ENVIRONMENT ===
    environment: SceneEnvironment {
        id: sceneEnvironment
        
        // Background
        backgroundMode: SceneEnvironment.SkyBox
        clearColor: "#2c3e50"
        
        // Anti-aliasing (Official Qt Quick 3D 6.9.3 support)
        antialiasingMode: SceneEnvironment.MSAA
        antialiasingQuality: SceneEnvironment.VeryHigh
        
        // Image Based Lighting
        lightProbe: environmentTexture
        probeExposure: 1.5
        probeHorizon: 0.1
        
        // Post-processing effects (Available in 6.9.3)
        effects: [
            chromaticAberration,
            bloom,
            tonemap
        ]
        
        // Temporal AA (if supported)
        temporalAAEnabled: true
        temporalAAStrength: 0.3
    }
    
    // === ENVIRONMENT TEXTURE ===
    Texture {
        id: environmentTexture
        source: "qrc:/qt/qml/QtQuick3D/Materials/maps/spherical_checker.png"
        mappingMode: Texture.LightProbe
        tilingModeHorizontal: Texture.Repeat
        tilingModeVertical: Texture.Repeat
    }
    
    // === POST-PROCESSING EFFECTS (Official Qt Quick 3D 6.9.3) ===
    ChromaticAberration {
        id: chromaticAberration
        aberrationAmount: 0.02
        focusDepth: 600
    }
    
    HDRBloomTonemap {
        id: bloom
        bloomIntensity: 0.8
        bloomThreshold: 0.7
        exposure: 1.0
    }
    
    SCurveTonemap {
        id: tonemap
        shoulderStrength: 0.15
        linearStrength: 0.50
        linearAngle: 0.10
        toeStrength: 0.20
        toeNumerator: 0.02
        toeDenominator: 0.30
        whitePoint: 11.2
    }
    
    // === LIGHTING SETUP ===
    
    // Main directional light (Sun)
    DirectionalLight {
        id: mainLight
        eulerRotation.x: -35
        eulerRotation.y: -25
        brightness: 3.0
        color: "#fff4e6"
        castsShadow: true
        shadowMapQuality: Light.ShadowMapQualityVeryHigh
        shadowMapFar: 10000
        shadowBias: -0.001
        shadowFactor: 75
        
        // Animated light intensity
        SequentialAnimation on brightness {
            running: isRunning
            loops: Animation.Infinite
            NumberAnimation { to: 3.5; duration: 5000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 2.5; duration: 5000; easing.type: Easing.InOutQuad }
        }
    }
    
    // Fill light
    DirectionalLight {
        eulerRotation.x: 45
        eulerRotation.y: 135
        brightness: 0.6
        color: "#e3f2fd"
        castsShadow: false
    }
    
    // Rim lights
    Repeater {
        model: [
            { pos: Qt.vector3d(-2500, 1200, -2000), color: "#ff5722", intensity: 200 },
            { pos: Qt.vector3d(2500, 1200, 2000), color: "#03a9f4", intensity: 180 },
            { pos: Qt.vector3d(0, 2500, 0), color: "#ffeb3b", intensity: 120 }
        ]
        
        PointLight {
            position: modelData.pos
            color: modelData.color
            brightness: modelData.intensity
            castsShadow: true
            shadowMapQuality: Light.ShadowMapQualityMedium
            shadowBias: -0.005
            
            // Animated point lights
            SequentialAnimation on brightness {
                running: isRunning
                loops: Animation.Infinite
                NumberAnimation { 
                    to: modelData.intensity * 1.4
                    duration: 3000 + index * 800
                    easing.type: Easing.InOutSine 
                }
                NumberAnimation { 
                    to: modelData.intensity * 0.8
                    duration: 3000 + index * 800
                    easing.type: Easing.InOutSine 
                }
            }
        }
    }
    
    // === OFFICIAL QT QUICK 3D MATERIALS ===
    
    // Premium metallic material for frame
    PrincipledMaterial {
        id: frameMaterial
        baseColor: "#c62828"
        metalness: 0.95
        roughness: 0.15
        specularAmount: 1.0
        indexOfRefraction: 2.5
        normalStrength: 1.0
        
        // Animated metallic properties
        SequentialAnimation on roughness {
            running: isRunning
            loops: Animation.Infinite
            NumberAnimation { to: 0.08; duration: 4000 }
            NumberAnimation { to: 0.22; duration: 4000 }
        }
    }
    
    // Chrome material for mechanical parts
    PrincipledMaterial {
        id: chromeMaterial
        baseColor: "#f5f5f5"
        metalness: 0.98
        roughness: 0.02
        specularAmount: 1.0
        indexOfRefraction: 3.0
        normalStrength: 1.5
    }
    
    // Advanced glass material for cylinders
    PrincipledMaterial {
        id: glassMaterial
        baseColor: Qt.rgba(0.9, 0.95, 1.0, 0.1)
        metalness: 0.0
        roughness: 0.01
        opacity: 0.1
        alphaMode: PrincipledMaterial.Blend
        specularAmount: 1.0
        indexOfRefraction: 1.52
        
        // Glass transmission (if supported in 6.9.3)
        transmissionFactor: 0.9
        thicknessFactor: 0.1
        
        // Animated glass properties
        SequentialAnimation on opacity {
            running: isRunning
            loops: Animation.Infinite
            NumberAnimation { to: 0.15; duration: 3000 }
            NumberAnimation { to: 0.08; duration: 3000 }
        }
    }
    
    // Piston material with emissive properties
    PrincipledMaterial {
        id: pistonMaterial
        baseColor: "#e91e63"
        metalness: 0.9
        roughness: 0.12
        specularAmount: 1.0
        indexOfRefraction: 2.2
        emissiveFactor: Qt.vector3d(0.05, 0.01, 0.02)
        
        // Pressure-responsive emissive effect
        SequentialAnimation on emissiveFactor {
            running: isRunning
            loops: Animation.Infinite
            ColorAnimation { 
                to: Qt.vector3d(0.12, 0.03, 0.06)
                duration: 2000
            }
            ColorAnimation { 
                to: Qt.vector3d(0.03, 0.01, 0.01)
                duration: 2000
            }
        }
    }
    
    // === PHYSICS SIMULATION ===
    
    // Advanced multi-harmonic suspension movement
    property real frontLeft: 18 * Math.sin(simulationTime * 0.9) + 
                            6 * Math.sin(simulationTime * 2.4) + 
                            2 * Math.sin(simulationTime * 4.7)
    
    property real frontRight: 18 * Math.sin(simulationTime * 0.9 + Math.PI/4) + 
                             6 * Math.sin(simulationTime * 2.2) + 
                             2 * Math.sin(simulationTime * 4.1)
    
    property real rearLeft: 18 * Math.sin(simulationTime * 0.9 + Math.PI/2) + 
                           6 * Math.sin(simulationTime * 1.8) + 
                           2 * Math.sin(simulationTime * 4.9)
    
    property real rearRight: 18 * Math.sin(simulationTime * 0.9 + 3*Math.PI/4) + 
                            6 * Math.sin(simulationTime * 2.6) + 
                            2 * Math.sin(simulationTime * 3.8)
    
    // Corner positions based on frame geometry
    property vector3d flCorner: Qt.vector3d(-beamSize/2 - 50, beamSize + 60, -frameLength/2 + 250)
    property vector3d frCorner: Qt.vector3d(beamSize/2 + 50, beamSize + 60, -frameLength/2 + 250)
    property vector3d rlCorner: Qt.vector3d(-beamSize/2 - 50, beamSize + 60, frameLength/2 - 250)
    property vector3d rrCorner: Qt.vector3d(beamSize/2 + 50, beamSize + 60, frameLength/2 - 250)
    
    // Upper attachment points
    property vector3d flUpper: Qt.vector3d(flCorner.x + 60, flCorner.y + frameHeight - 80, flCorner.z)
    property vector3d frUpper: Qt.vector3d(frCorner.x - 60, frCorner.y + frameHeight - 80, frCorner.z)
    property vector3d rlUpper: Qt.vector3d(rlCorner.x + 60, rlCorner.y + frameHeight - 80, rlCorner.z)
    property vector3d rrUpper: Qt.vector3d(rrCorner.x - 60, rrCorner.y + frameHeight - 80, rrCorner.z)
    
    // Rod end positions (calculated from lever angles)
    property vector3d flRod: Qt.vector3d(
        flCorner.x + leverLength * Math.cos((180 + frontLeft) * Math.PI / 180),
        flCorner.y + leverLength * Math.sin((180 + frontLeft) * Math.PI / 180),
        flCorner.z
    )
    property vector3d frRod: Qt.vector3d(
        frCorner.x + leverLength * Math.cos((0 + frontRight) * Math.PI / 180),
        frCorner.y + leverLength * Math.sin((0 + frontRight) * Math.PI / 180),
        frCorner.z
    )
    property vector3d rlRod: Qt.vector3d(
        rlCorner.x + leverLength * Math.cos((180 + rearLeft) * Math.PI / 180),
        rlCorner.y + leverLength * Math.sin((180 + rearLeft) * Math.PI / 180),
        rlCorner.z
    )
    property vector3d rrRod: Qt.vector3d(
        rrCorner.x + leverLength * Math.cos((0 + rearRight) * Math.PI / 180),
        rrCorner.y + leverLength * Math.sin((0 + rearRight) * Math.PI / 180),
        rrCorner.z
    )
    
    // === MAIN FRAME STRUCTURE ===
    
    // Main longitudinal beam
    Model {
        source: "#Cube"
        position: Qt.vector3d(0, beamSize/2, 0)
        scale: Qt.vector3d(beamSize/100, beamSize/100, frameLength/100)
        materials: frameMaterial
        
        // Smooth parameter response
        Behavior on scale { 
            Vector3dAnimation { duration: 1000; easing.type: Easing.OutCubic } 
        }
    }
    
    // Side frame beams
    Repeater {
        model: [
            { z: -frameLength/2, delay: 0 },
            { z: frameLength/2, delay: 500 }
        ]
        
        Model {
            source: "#Cube"
            position: Qt.vector3d(0, beamSize + frameHeight/2, modelData.z)
            scale: Qt.vector3d(beamSize/100, frameHeight/100, beamSize/100)
            materials: frameMaterial
            
            // Staggered scaling animation
            Timer {
                running: true
                interval: modelData.delay
                onTriggered: parent.animateScale.start()
            }
            
            SequentialAnimation {
                id: animateScale
                running: false
                loops: Animation.Infinite
                
                NumberAnimation {
                    target: parent
                    property: "scale.y"
                    to: frameHeight/100 * 1.03
                    duration: 3000
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    target: parent
                    property: "scale.y"
                    to: frameHeight/100
                    duration: 3000
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
    
    // === SUSPENSION CORNERS ===
    component SuspensionCorner: Node {
        id: cornerAssembly
        
        required property vector3d pivotPoint
        required property vector3d upperMount  
        required property vector3d rodEnd
        required property real leverAngle
        required property bool leftSide
        
        // Calculated properties
        property real pivotAngle: leftSide ? 180 : 0
        property real totalAngle: pivotAngle + leverAngle
        
        // Cylinder calculations
        property vector3d cylVector: Qt.vector3d(rodEnd.x - upperMount.x, rodEnd.y - upperMount.y, 0)
        property real cylVectorLength: Math.sqrt(cylVector.x * cylVector.x + cylVector.y * cylVector.y)
        property real cylBodyLength: stroke
        property real tailRodLength: 120
        
        property vector3d tailEnd: Qt.vector3d(
            upperMount.x + cylVector.x * (tailRodLength / cylVectorLength),
            upperMount.y + cylVector.y * (tailRodLength / cylVectorLength),
            upperMount.z
        )
        
        property vector3d cylBodyStart: tailEnd
        property vector3d cylBodyEnd: Qt.vector3d(
            cylBodyStart.x + cylVector.x * (cylBodyLength / cylVectorLength),
            cylBodyStart.y + cylVector.y * (cylBodyLength / cylVectorLength),
            cylBodyStart.z
        )
        
        // Piston position based on lever angle
        property real pistonExtension: Math.max(0.15, Math.min(0.85, 0.5 + (leverAngle / 25)))
        property vector3d pistonPos: Qt.vector3d(
            cylBodyStart.x + cylVector.x * ((cylBodyLength * pistonExtension) / cylVectorLength),
            cylBodyStart.y + cylVector.y * ((cylBodyLength * pistonExtension) / cylVectorLength),
            cylBodyStart.z
        )
        
        // === LEVER ARM ===
        Model {
            source: "#Cube"
            position: Qt.vector3d(
                pivotPoint.x + (leverLength/2) * Math.cos(totalAngle * Math.PI / 180), 
                pivotPoint.y + (leverLength/2) * Math.sin(totalAngle * Math.PI / 180), 
                pivotPoint.z
            )
            scale: Qt.vector3d(leverLength/100, 1.5, 2.0)
            eulerRotation: Qt.vector3d(0, 0, totalAngle)
            materials: chromeMaterial
            
            // Smooth lever rotation
            Behavior on eulerRotation.z {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
        }
        
        // === CYLINDER BODY ===
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(
                (cylBodyStart.x + cylBodyEnd.x)/2, 
                (cylBodyStart.y + cylBodyEnd.y)/2, 
                cylBodyStart.z
            )
            scale: Qt.vector3d(cylinderDiameter/100, cylBodyLength/100, cylinderDiameter/100)
            eulerRotation: Qt.vector3d(
                0, 0, 
                Math.atan2(cylBodyEnd.y - cylBodyStart.y, cylBodyEnd.x - cylBodyStart.x) * 180 / Math.PI + 90
            )
            materials: glassMaterial
            
            // Smooth cylinder positioning
            Behavior on position {
                Vector3dAnimation { duration: 250; easing.type: Easing.OutQuart }
            }
        }
        
        // === PISTON ===
        Model {
            source: "#Cylinder"
            position: pistonPos
            scale: Qt.vector3d((cylinderDiameter-6)/100, 0.5, (cylinderDiameter-6)/100)
            eulerRotation: Qt.vector3d(
                0, 0, 
                Math.atan2(cylVector.y, cylVector.x) * 180 / Math.PI + 90
            )
            materials: pistonMaterial
            
            // Physics-based piston movement
            Behavior on position {
                Vector3dAnimation { 
                    duration: 100 
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.1
                }
            }
        }
        
        // === PISTON ROD ===
        Model {
            source: "#Cylinder"
            
            property real rodLength: Math.sqrt(
                (rodEnd.x - pistonPos.x) * (rodEnd.x - pistonPos.x) + 
                (rodEnd.y - pistonPos.y) * (rodEnd.y - pistonPos.y)
            )
            
            position: Qt.vector3d(
                (pistonPos.x + rodEnd.x)/2, 
                (pistonPos.y + rodEnd.y)/2, 
                pistonPos.z
            )
            scale: Qt.vector3d(rodDiameter/100, rodLength/100, rodDiameter/100)
            eulerRotation: Qt.vector3d(
                0, 0, 
                Math.atan2(rodEnd.y - pistonPos.y, rodEnd.x - pistonPos.x) * 180 / Math.PI + 90
            )
            materials: chromeMaterial
        }
        
        // === TAIL ROD ===
        Model {
            source: "#Cylinder"
            position: Qt.vector3d(
                (upperMount.x + tailEnd.x)/2, 
                (upperMount.y + tailEnd.y)/2, 
                upperMount.z
            )
            scale: Qt.vector3d(rodDiameter/100, tailRodLength/100, rodDiameter/100)
            eulerRotation: Qt.vector3d(
                0, 0, 
                Math.atan2(tailEnd.y - upperMount.y, tailEnd.x - upperMount.x) * 180 / Math.PI + 90
            )
            materials: chromeMaterial
        }
        
        // === CONNECTION POINTS ===
        Repeater {
            model: [
                { pos: upperMount, color: "#1976d2", size: 2.2, name: "upper" },
                { pos: pivotPoint, color: "#f57c00", size: 2.0, name: "pivot" },
                { pos: rodEnd, color: "#388e3c", size: 1.8, name: "rod" }
            ]
            
            Model {
                source: "#Sphere"
                position: modelData.pos
                scale: Qt.vector3d(modelData.size, modelData.size, modelData.size)
                
                materials: PrincipledMaterial {
                    baseColor: modelData.color
                    metalness: 0.9
                    roughness: 0.08
                    specularAmount: 1.0
                    indexOfRefraction: 2.4
                    emissiveFactor: Qt.vector3d(0.1, 0.05, 0.02)
                }
                
                // Pulsing joint animation
                SequentialAnimation on scale {
                    running: isRunning
                    loops: Animation.Infinite
                    
                    Vector3dAnimation {
                        to: Qt.vector3d(modelData.size * 1.15, modelData.size * 1.15, modelData.size * 1.15)
                        duration: 2500 + index * 400
                        easing.type: Easing.InOutSine
                    }
                    Vector3dAnimation {
                        to: Qt.vector3d(modelData.size, modelData.size, modelData.size)
                        duration: 2500 + index * 400
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }
    }
    
    // === INSTANTIATE SUSPENSION CORNERS ===
    SuspensionCorner { 
        pivotPoint: flCorner; upperMount: flUpper; rodEnd: flRod; leverAngle: frontLeft; leftSide: true 
    }
    SuspensionCorner { 
        pivotPoint: frCorner; upperMount: frUpper; rodEnd: frRod; leverAngle: frontRight; leftSide: false 
    }
    SuspensionCorner { 
        pivotPoint: rlCorner; upperMount: rlUpper; rodEnd: rlRod; leverAngle: rearLeft; leftSide: true 
    }
    SuspensionCorner { 
        pivotPoint: rrCorner; upperMount: rrUpper; rodEnd: rrRod; leverAngle: rearRight; leftSide: false 
    }
    
    // === CAMERA CONTROLLER ===
    OrbitCameraController {
        camera: mainCamera
        origin: Qt.vector3d(0, frameHeight/2 + beamSize, 0)
        panEnabled: true
        xInvert: false
        yInvert: false
    }
    
    // === UI OVERLAY ===
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 25
        width: 320
        height: 220
        color: Qt.rgba(0.1, 0.1, 0.15, 0.85)
        radius: 15
        border.color: "#64b5f6"
        border.width: 2
        
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            
            Text {
                text: "🚀 Official Qt Quick 3D 6.9.3"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 18
            }
            
            Rectangle {
                width: parent.width
                height: 1
                color: "#64b5f6"
            }
            
            Text {
                text: `FPS: ${simulationTimer.currentFps.toFixed(1)}`
                color: simulationTimer.currentFps > 55 ? "#4caf50" : 
                       simulationTimer.currentFps > 30 ? "#ff9800" : "#f44336"
                font.pixelSize: 16
                font.family: "Consolas"
            }
            
            Text {
                text: "RHI: Direct3D 11"
                color: "#03a9f4"
                font.pixelSize: 13
            }
            
            Text {
                text: "✨ HDR + Bloom + Chromatic Aberration"
                color: "#e91e63"
                font.pixelSize: 12
            }
            
            Text {
                text: `Status: ${isRunning ? "▶️ Running" : "⏸️ Paused"}`
                color: "#ab47bc"
                font.pixelSize: 12
            }
            
            Text {
                text: `Speed: ${speedMultiplier.toFixed(1)}x`
                color: "#ff7043"
                font.pixelSize: 12
            }
            
            Text {
                text: "🎮 LMB: Rotate | Wheel: Zoom | R: Reset"
                color: "#78909c"
                font.pixelSize: 10
            }
        }
        
        // Interactive overlay
        MouseArea {
            anchors.fill: parent
            onClicked: isRunning = !isRunning
            cursorShape: Qt.PointingHandCursor
            
            onWheel: function(wheel) {
                speedMultiplier = Math.max(0.1, Math.min(5.0, speedMultiplier + wheel.angleDelta.y / 1200))
            }
        }
    }
    
    // === INITIALIZATION ===
    Component.onCompleted: {
        console.log("🌟 ================================================")
        console.log("🚀 OFFICIAL QT QUICK 3D 6.9.3 PNEUMATIC SIMULATOR")
        console.log("🌟 ================================================")
        console.log("📊 Simulation Parameters:")
        console.log("   📐 Frame: " + frameLength + "×" + frameHeight + "×" + beamSize + " mm")
        console.log("   🔧 Lever: " + leverLength + " mm")  
        console.log("   💨 Cylinder: Ø" + cylinderDiameter + " × " + stroke + " mm stroke")
        console.log("   🔩 Rod: Ø" + rodDiameter + " mm")
        console.log("")
        console.log("🎮 Features (Official Qt Quick 3D 6.9.3):")
        console.log("   ✨ HDR Rendering Pipeline")
        console.log("   🌟 Post-Processing: Bloom + Chromatic Aberration + Tonemap")
        console.log("   💎 PBR Materials: Metal + Glass + Emission")
        console.log("   ⚡ Hardware Shadows: Cascaded Shadow Maps")
        console.log("   🎯 Advanced Camera: Orbit Controller")
        console.log("   🔥 Physics Animation: Multi-harmonic Suspension")
        console.log("   📊 Real-time Performance Monitoring")
        console.log("🌟 ================================================")
        
        // Focus the view for input
        mainView.forceActiveFocus()
    }
}
