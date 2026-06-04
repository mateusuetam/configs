import QtQuick
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: lockHeader

    readonly property string headerText: "MU-TH-UR 6000 // INTERFACE DE SESSÃO SEGURA"
    readonly property color accentColor: "#504945"
    readonly property int labelFontSize: 14

    Layout.fillWidth: true
    spacing: 5

    Text {
        text: lockHeader.headerText
        font.family: Theme.fontFamily
        font.pixelSize: lockHeader.labelFontSize
        font.bold: true
        color: lockHeader.accentColor
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 1
        color: lockHeader.accentColor
    }
}
