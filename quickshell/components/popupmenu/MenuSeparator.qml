pragma ComponentBehavior: Bound
import QtQuick
import "../themeengine"

Item {
    id: separatorRoot
    readonly property color menuBorderColor: ColorRegistry.menuBorderColor
    Rectangle {
        width: parent.width - 12
        height: 1
        anchors.centerIn: parent
        color: separatorRoot.menuBorderColor
        opacity: 0.6
    }
}
