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
    readonly property bool hasIcon: !!_actualData && _actualData.icon !== undefined && _actualData.icon !== ""

    Rectangle {
        anchors.fill: parent
        color: (mouseArea.containsMouse || actionRoot.isCurrentKeyboardItem) ? actionRoot.menuPopup.itemHoverColor : "transparent"

        Row {
            anchors.fill: parent
            anchors.leftMargin: 8
            spacing: 8

            Image {
                id: itemIcon
                visible: actionRoot.hasIcon
                width: actionRoot.menuPopup.iconSize
                height: actionRoot.menuPopup.iconSize
                anchors.verticalCenter: parent.verticalCenter
                source: (actionRoot._actualData && actionRoot._actualData.icon) || ""
                sourceSize.width: actionRoot.menuPopup.iconSize
                sourceSize.height: actionRoot.menuPopup.iconSize
            }

            Text {
                id: itemText
                text: (actionRoot._actualData && actionRoot._actualData.text) || ""
                width: actionRoot.width - (actionRoot.hasIcon ? (actionRoot.menuPopup.iconSize + 24) : 16)
                anchors.verticalCenter: parent.verticalCenter
                color: (mouseArea.containsMouse || actionRoot.isCurrentKeyboardItem) ? actionRoot.menuPopup.itemTextHoverColor : actionRoot.menuPopup.itemTextColor
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
                if (mouse.button === Qt.LeftButton) {
                    if (actionRoot._actualData) {
                        actionRoot.triggered(actionRoot._actualData);
                    }
                }
            }
        }
    }
}
