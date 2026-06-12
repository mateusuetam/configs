pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: separatorRoot

    required property var menuPopup

    Rectangle {
        width: parent.width - 12
        height: 1
        anchors.centerIn: parent
        color: separatorRoot.menuPopup.menuBorderColor
        opacity: 0.6
    }
}