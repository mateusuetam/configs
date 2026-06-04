import QtQuick
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: lockClock

    readonly property color clockColor: "#689d6a"
    readonly property color labelColor: "#504945"
    readonly property int clockFontSize: 110
    readonly property int labelFontSize: 12
    readonly property int labelLetterSpacing: 4
    readonly property string labelText: "SOBREPOSIÇÃO DE HORA DO SISTEMA"

    Layout.alignment: Qt.AlignHCenter
    Layout.topMargin: 40
    spacing: 0

    Text {
        id: clock

        property var date: new Date()

        Layout.alignment: Qt.AlignHCenter

        renderType: Text.NativeRendering
        font.family: Theme.fontFamily
        font.pixelSize: lockClock.clockFontSize
        font.bold: true
        color: lockClock.clockColor

        Timer {
            running: true
            repeat: true
            interval: 1000
            onTriggered: clock.date = new Date()
        }

        text: {
            const hours = this.date.getHours().toString().padStart(2, '0');
            const minutes = this.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: lockClock.labelText
        font.family: Theme.fontFamily
        font.pixelSize: lockClock.labelFontSize
        font.letterSpacing: lockClock.labelLetterSpacing
        color: lockClock.labelColor
    }
}
