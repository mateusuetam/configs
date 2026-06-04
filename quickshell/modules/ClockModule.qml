import QtQuick
import Quickshell
import "../components/theme"

Text {
    id: clockModule

    readonly property color labelColor: "#ebdbb2"

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize

    color: clockModule.labelColor
    anchors.verticalCenter: parent.verticalCenter

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }

    text: `${Qt.formatDateTime(systemClock.date, "ddd, d 'de' MMMM")} | ${Qt.formatDateTime(systemClock.date, "hh:mm")}`
}
