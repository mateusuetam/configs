pragma ComponentBehavior: Bound
import QtQuick
import "../themeengine"

Item {
    id: searchRoot

    readonly property string labelFontFamily: TypographyRegistry.appliedFontFamily
    readonly property int labelFontSize: TypographyRegistry.appliedMenuFontSize
    readonly property color menuTextColor: ColorRegistry.menuTextColor
    readonly property color menuBorderColor: ColorRegistry.menuBorderColor
    readonly property color menuBackgroundColor: ColorRegistry.menuBackgroundColor

    property int itemHeight: 26

    property alias text: textInput.text

    signal navigationDownRequested
    signal actionTriggeredRequested

    function forceFocusNow() {
        textInput.forceActiveFocus();
    }

    width: parent ? parent.width : 200
    height: itemHeight + 8

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: Qt.darker(searchRoot.menuBackgroundColor, 1.15)
        border.color: searchRoot.menuBorderColor
        border.width: 1

        TextInput {
            id: textInput
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            verticalAlignment: TextInput.AlignVCenter
            font.family: searchRoot.labelFontFamily
            font.pixelSize: searchRoot.labelFontSize
            color: searchRoot.menuTextColor
            focus: true
            selectByMouse: true
            clip: true

            Keys.onPressed: event => {
                switch (event.key) {
                case Qt.Key_Down:
                case Qt.Key_Tab:
                    searchRoot.navigationDownRequested();
                    event.accepted = true;
                    break;
                case Qt.Key_Return:
                case Qt.Key_Enter:
                    searchRoot.actionTriggeredRequested();
                    event.accepted = true;
                    break;
                }
            }
        }

        Text {
            anchors.fill: textInput
            anchors.leftMargin: textInput.anchors.leftMargin
            verticalAlignment: Text.AlignVCenter
            text: "Pesquisar..."
            font: textInput.font
            color: searchRoot.menuTextColor
            opacity: 0.4
            visible: textInput.text === ""
        }
    }
}
