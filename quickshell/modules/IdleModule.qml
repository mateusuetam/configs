import QtQuick
import Quickshell.Wayland
import "../components/theme"

Item {
    id: idleModule

    readonly property color activatedColor: "#8ec07c"
    readonly property color deactivatedColor: "#928374"
    readonly property color labelColor: "#ebdbb2"

    readonly property bool isActive: inhibitor.enabled
    property var parentWindow: null

    IdleInhibitor {
        id: inhibitor
        window: idleModule.parentWindow
        enabled: false
    }

    implicitWidth: idleText.implicitWidth
    implicitHeight: 30

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            inhibitor.enabled = !inhibitor.enabled;
        }
    }

    Text {
        id: idleText

        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        anchors.verticalCenter: parent.verticalCenter
        textFormat: Text.RichText

        color: idleModule.isActive ? idleModule.activatedColor : idleModule.deactivatedColor

        text: {
            var prefix = `<span style="color: ${idleModule.labelColor};">idle:</span>`;
            return idleModule.isActive ? `${prefix} watching` : `${prefix} idling`;
        }
    }
}
