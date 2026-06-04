import QtQuick
import Quickshell.Services.Mpris
import "../components/theme"

Item {
    id: mprisModule

    readonly property color playingColor: "#689d6a"
    readonly property color pausedColor: "#458588"

    readonly property var activePlayer: {
        const list = Mpris.players.values;

        if (!list.length)
            return null;

        for (const p of list) {
            if (p?.dbusName?.includes("playerctld"))
                continue;

            if (p?.trackTitle)
                return p;
        }

        return null;
    }

    readonly property int maxWidth: 550

    implicitWidth: visible ? Math.min(mprisText.implicitWidth, maxWidth) : 0
    implicitHeight: 30

    visible: activePlayer !== null

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: mouse => {
            const player = mprisModule.activePlayer;

            if (!player)
                return;

            if (mouse.button === Qt.LeftButton && player.canTogglePlaying) {
                player.togglePlaying();
            } else if (mouse.button === Qt.RightButton && player.canGoNext) {
                player.next();
            } else if (mouse.button === Qt.MiddleButton && player.canGoPrevious) {
                player.previous();
            }
        }
    }

    Text {
        id: mprisText

        width: parent.implicitWidth
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter

        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize

        color: {
            const player = mprisModule.activePlayer;
            return player?.isPlaying ? mprisModule.playingColor : mprisModule.pausedColor;
        }

        text: {
            const player = mprisModule.activePlayer;

            if (!player?.trackTitle)
                return "";

            const icon = player.isPlaying ? "||" : ">";
            const artist = player.trackArtist || "Desconhecido";

            return `${icon} ${player.trackTitle} - ${artist}`;
        }
    }
}
