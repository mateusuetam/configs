import QtQuick
import Quickshell.Io
import "../components/theme"

Item {
    id: powermenuModule

    readonly property color sessionColor: "#83a598"

    implicitWidth: powerText.implicitWidth
    implicitHeight: 30

    Process {
        id: powerCmd
        command: ["sh", "-c", "$HOME/Documentos/repos/configs/scripts/powermenu.sh"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            powerCmd.startDetached();
        }
    }

    Text {
        id: powerText

        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        color: powermenuModule.sessionColor
        anchors.verticalCenter: parent.verticalCenter
        text: "-SESS-"
    }
}
