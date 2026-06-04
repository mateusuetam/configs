import QtQuick
import Quickshell.Io
import "../components/theme"

Item {
    id: backlightModule

    readonly property color brightnessColor: "#fabd2f"
    property int brightnessPercent: 50

    implicitWidth: backlightText.implicitWidth
    implicitHeight: 30

    Process {
        id: readBrightness
        command: ["sh", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'"]

        stdout: StdioCollector {
            onStreamFinished: {
                var val = parseInt(this.text.trim());
                if (!isNaN(val)) {
                    backlightModule.brightnessPercent = val;
                }
            }
        }

        Component.onCompleted: readBrightness.running = true
    }

    Process {
        id: changeBrightness

        onExited: {
            readBrightness.running = true;
        }
    }

    Process {
        id: gammastepMenu
        command: ["sh", "-c", "$HOME/Documentos/repos/configs/scripts/redfilter.sh"]
    }

    Process {
        id: gammastepToggle
        command: ["sh", "-c", "pkill gammastep || gammastep -O 2500 &"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                gammastepMenu.running = true;
            } else if (mouse.button === Qt.RightButton) {
                gammastepToggle.running = true;
            }
        }

        onWheel: wheel => {
            if (changeBrightness.running)
                return;

            if (wheel.angleDelta.y > 0) {
                changeBrightness.command = ["brightnessctl", "set", "+1%"];
            } else {
                changeBrightness.command = ["brightnessctl", "set", "1%-"];
            }

            changeBrightness.running = true;
        }
    }

    Text {
        id: backlightText
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        color: backlightModule.brightnessColor
        anchors.verticalCenter: parent.verticalCenter
        text: `light: ${backlightModule.brightnessPercent}%`
    }
}
