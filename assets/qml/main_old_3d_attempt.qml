import QtQuick
import QtQuick3D

/*
 * FIXED: Proper layering - Item root with View3D and 2D overlay
 */
Item {
    id: root
    anchors.fill: parent
    
    // 3D View (background layer)
    View3D {
        id: view3d
        anchors.fill: parent
        
        // ������ ��� ��� ���������
        environment: SceneEnvironment {
            backgroundMode: SceneEnvironment.Color
            clearColor: "#1a1a2e"  // �����-�����
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }
        
        // ������ - ������� �� �����
        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, 0, 5)  // 5 ������ �� ������
            eulerRotation: Qt.vector3d(0, 0, 0)  // ����� ������
        }
        
        // ���� - ����� ����� ���� �����
        DirectionalLight {
            eulerRotation.x: -30
            eulerRotation.y: 30
            brightness: 1.0
        }
        
        // ���������� (3D �����)
        Model {
            id: sphere
            source: "#Sphere"  // ���������� ����������� �����
            
            // ������� � ������ (0, 0, 0)
            position: Qt.vector3d(0, 0, 0)
            
            // ������ - ������ 1 ����
            scale: Qt.vector3d(1, 1, 1)
            
            // ������� ���� ��� ���������
            materials: PrincipledMaterial {
                baseColor: "#ff4444"  // ����-�������
                metalness: 0.0
                roughness: 0.5
            }
            
            // ��������: �������� ������ ��� Y (�����������)
            NumberAnimation on eulerRotation.y {
                from: 0      // ������: 0 ��������
                to: 360      // �����: 360 �������� (������ ������)
                duration: 3000  // 3 ������� �� ������
                loops: Animation.Infinite  // ����������� ����������
                running: true  // ��������� �����
            }
        }
    }
    
    // 2D Overlay (foreground layer - ON TOP of 3D)
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        width: 300
        height: 80
        color: "#20000000"
        border.color: "#40ffffff"
        border.width: 1
        radius: 5
        
        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5
            
            Text {
                text: "������� ����������� ����������"
                color: "#ffffff"
                font.pixelSize: 16
                font.bold: true
            }
            
            Text {
                text: "3D ����� � ���������"
                color: "#aaaaaa"
                font.pixelSize: 12
            }
            
            Text {
                text: "Qt Quick 3D (RHI/D3D11)"
                color: "#888888"
                font.pixelSize: 10
            }
        }
    }
}
