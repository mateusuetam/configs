import QtQuick
import Quickshell.Services.Pipewire
import "../components/theme"

Item {
    id: volumeModule

    readonly property color mutedColor: "#fe8019"
    readonly property color activeColor: "#b8bb26"
    readonly property color labelColor: "#ebdbb2"

    readonly property var audioNode: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
    readonly property int volPercent: audioNode ? Math.round(audioNode.volume * 100) : 0
    readonly property bool volMuted: audioNode ? audioNode.muted : false

    PwObjectTracker {
        id: sinkTracker
        objects: [Pipewire.defaultAudioSink]
    }

    implicitWidth: volText.implicitWidth
    implicitHeight: 30
    visible: Pipewire.ready && Pipewire.defaultAudioSink !== null

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (volumeModule.audioNode)
                volumeModule.audioNode.muted = !volumeModule.audioNode.muted;
        }

        onWheel: wheel => {
            if (!volumeModule.audioNode)
                return;
            var step = 0.01;
            if (wheel.angleDelta.y > 0) {
                volumeModule.audioNode.volume = Math.min(1.0, volumeModule.audioNode.volume + step);
            } else {
                volumeModule.audioNode.volume = Math.max(0.0, volumeModule.audioNode.volume - step);
            }
        }
    }

    Text {
        id: volText
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        anchors.verticalCenter: parent.verticalCenter
        textFormat: Text.RichText

        color: volumeModule.volMuted ? volumeModule.mutedColor : volumeModule.activeColor

        text: {
            var prefix = `<span style="color: ${volumeModule.labelColor};">vol:</span>`;
            return volumeModule.volMuted ? `${prefix} muted` : `${prefix} ${volumeModule.volPercent}%`;
        }
    }
}
