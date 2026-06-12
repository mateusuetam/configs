pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: actionRoot

    required property var safeData
    required property var menuPopup
    required property bool isEnabled
    required property bool isSubmenu
    required property bool isToggle
    required property bool isCurrentKeyboardItem

    signal triggered(var dataObj)

    readonly property var _actualData: actionRoot.safeData || ({})

    opacity: actionRoot.isEnabled ? 1.0 : 0.5

    Rectangle {
        anchors.fill: parent
        color: (actionRoot.isEnabled && (mouseArea.containsMouse || actionRoot.isCurrentKeyboardItem)) ? actionRoot.menuPopup.itemHoverColor : "transparent"

        Row {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 8

            Text {
                id: itemText
                text: actionRoot._actualData.text || ""
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                color: (actionRoot.isEnabled && (mouseArea.containsMouse || actionRoot.isCurrentKeyboardItem)) ? actionRoot.menuPopup.itemTextHoverColor : actionRoot.menuPopup.itemTextColor
                font.family: actionRoot.menuPopup.labelFontFamily
                font.pixelSize: actionRoot.menuPopup.menuFontSize
                elide: Text.ElideRight
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: actionRoot.isEnabled
            hoverEnabled: actionRoot.isEnabled
            cursorShape: hoverEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.LeftButton
            onPressed: mouse => {
                mouse.accepted = true;
                if (mouse.button === Qt.LeftButton && actionRoot._actualData) {
                    actionRoot.triggered(actionRoot._actualData);
                }
            }
        }
    }
}
