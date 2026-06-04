import QtQuick
import Quickshell.Services.Pipewire
import "../components/theme"

Item {
    id: micModule

    readonly property color mutedColor: "#fe8019"
    readonly property color activeColor: "#b8bb26"
    readonly property color labelColor: "#ebdbb2"

    readonly property var micNode: Pipewire.defaultAudioSource ? Pipewire.defaultAudioSource.audio : null
    readonly property int micPercent: micNode ? Math.round(micNode.volume * 100) : 0
    readonly property bool micMuted: micNode ? micNode.muted : false

    PwObjectTracker {
        id: sourceTracker
        objects: [Pipewire.defaultAudioSource]
    }

    implicitWidth: micText.implicitWidth
    implicitHeight: 30
    visible: Pipewire.ready && Pipewire.defaultAudioSource !== null

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (micModule.micNode)
                micModule.micNode.muted = !micModule.micNode.muted;
        }

        onWheel: wheel => {
            if (!micModule.micNode)
                return;
            var step = 0.01;
            if (wheel.angleDelta.y > 0) {
                micModule.micNode.volume = Math.min(1.0, micModule.micNode.volume + step);
            } else {
                micModule.micNode.volume = Math.max(0.0, micModule.micNode.volume - step);
            }
        }
    }

    Text {
        id: micText
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        anchors.verticalCenter: parent.verticalCenter
        textFormat: Text.RichText

        color: micModule.micMuted ? micModule.mutedColor : micModule.activeColor

        text: {
            var prefix = `<span style="color: ${micModule.labelColor};">mic:</span>`;
            return micModule.micMuted ? `${prefix} muted` : `${prefix} ${micModule.micPercent}%`;
        }
    }
}
