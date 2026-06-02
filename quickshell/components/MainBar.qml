import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../modules"

PanelWindow {
    id: barWindow

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 30
    exclusiveZone: 30
    aboveWindows: true
    focusable: false

    Component.onCompleted: {
        if (this.WlrLayershell !== null) {
            this.WlrLayershell.layer = WlrLayer.Top;
        }
    }

    // --- RENDERIZAÇÃO DA BARRA ---
    Rectangle {
        anchors.fill: parent
        color: "#282828"

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#3c3836"
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 6
            anchors.rightMargin: 6

            // <<< LADO ESQUERDO <<<
            Row {
                id: leftModules
                spacing: 12
                Layout.alignment: Qt.AlignLeft | Qt.AlignVerticalCenter

                MprisModule {}
            }

            // >>> LADO DIREITO >>>
            Row {
                id: rightModules
                spacing: 12
                Layout.alignment: Qt.AlignRight | Qt.AlignVerticalCenter

                TrayModule {
                    parentWindow: barWindow
                }
                ClipboardModule {}
                IdleModule {
                    parentWindow: barWindow
                }
                MicrophoneModule {}
                VolumeModule {}
                BluetoothModule {}
                NetworkModule {}
                BacklightModule {}
                BatteryModule {}
                ClockModule {}
                PowerModule {}
            }
        }
    }
}
