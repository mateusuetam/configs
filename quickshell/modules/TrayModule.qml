pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../components/contextmenu"

Item {
    id: trayModule

    readonly property int iconSize: 20
    readonly property int itemSpacing: 8

    property var parentWindow: null

    implicitWidth: trayLayout.implicitWidth
    implicitHeight: 30

    visible: SystemTray.items !== undefined && SystemTray.items !== null

    ContextMenuHelper {
        id: menuHelper
    }

    LazyLoader {
        id: customMenuLoader
        loading: true

        ContextMenu {}
    }

    Row {
        id: trayLayout
        spacing: trayModule.itemSpacing
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItemDelegate
                width: trayModule.iconSize
                height: trayModule.iconSize
                anchors.verticalCenter: parent.verticalCenter

                required property var modelData
                readonly property var trayItem: trayItemDelegate.modelData

                Image {
                    anchors.fill: parent
                    source: trayItemDelegate.trayItem && trayItemDelegate.trayItem.icon ? trayItemDelegate.trayItem.icon : ""
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    sourceSize.width: trayModule.iconSize
                    sourceSize.height: trayModule.iconSize
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: mouse => {
                        if (!trayItemDelegate.trayItem)
                            return;

                        if (mouse.button === Qt.LeftButton) {
                            trayItemDelegate.trayItem.activate();
                        } else if (mouse.button === Qt.RightButton) {
                            if (trayItemDelegate.trayItem.hasMenu && trayItemDelegate.trayItem.menu) {
                                menuHelper.openMenu(customMenuLoader.item, trayModule.parentWindow, trayItemDelegate, trayItemDelegate.trayItem.menu);
                            }
                        }
                    }
                }
            }
        }
    }
}
