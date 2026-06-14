pragma ComponentBehavior: Bound
import QtQuick
import "../themeengine"

Rectangle {
    id: actionRoot

    readonly property string labelFontFamily: TypographyRegistry.appliedFontFamily
    readonly property int labelFontSize: TypographyRegistry.appliedMenuFontSize
    readonly property color menuTextColor: ColorRegistry.menuTextColor
    readonly property color menuTextHoverColor: ColorRegistry.menuTextHoverColor
    readonly property color menuHoverColor: ColorRegistry.menuHoverColor

    required property var safeData
    required property bool isEnabled
    required property bool isCurrentKeyboardItem

    signal triggered(var dataObj)

    readonly property var _actualData: actionRoot.safeData || ({})

    opacity: actionRoot.isEnabled ? 1.0 : 0.5
    color: (actionRoot.isEnabled && (mouseArea.containsMouse || actionRoot.isCurrentKeyboardItem)) ? actionRoot.menuHoverColor : "transparent"

    Text {
        id: itemText
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        verticalAlignment: Text.AlignVCenter
        text: (actionRoot._actualData && actionRoot._actualData.text) ? actionRoot._actualData.text : ""
        color: (actionRoot.isEnabled && (mouseArea.containsMouse || actionRoot.isCurrentKeyboardItem)) ? actionRoot.menuTextHoverColor : actionRoot.menuTextColor
        font.family: actionRoot.labelFontFamily
        font.pixelSize: actionRoot.labelFontSize
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: actionRoot.isEnabled
        hoverEnabled: actionRoot.isEnabled
        cursorShape: hoverEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton
        onPressed: {
            if (actionRoot._actualData) {
                actionRoot.triggered(actionRoot._actualData);
            }
        }
    }
}
