pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: wallpaperWindow

    property url sourcePath: "file://" + Quickshell.env("HOME") + "/Imagens/afina.png"
    readonly property int imageFillMode: Image.PreserveAspectCrop
    property var globalMenu: null

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "wallpaper"

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }
    exclusiveZone: 0
    focusable: false

    WallpaperModel {
        id: backendModel
        onWallpaperSelected: fileUrl => {
            wallpaperWindow.sourcePath = fileUrl;
        }
    }

    Connections {
        target: wallpaperWindow.globalMenu
        function onItemDataActionTriggered(actionType, data) {
            switch (actionType) {
            case "open_wallpaper_submenu":
                if (wallpaperWindow.globalMenu) {
                    wallpaperWindow.globalMenu.menuModel = backendModel.subMenuStructure;
                }
                break;
            case "change_wallpaper":
                backendModel.wallpaperSelected(data);
                break;
            }
        }
    }

    readonly property var desktopMenuStructure: [
        {
            type: "action",
            text: "Wallpaper Changer",
            icon: "",
            preventClose: true,
            actionType: "open_wallpaper_submenu",
            actionData: null
        }
    ]

    Image {
        anchors.fill: parent
        source: wallpaperWindow.sourcePath
        fillMode: wallpaperWindow.imageFillMode
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        asynchronous: true
        cache: true
    }

    MouseArea {
        id: wallpaperArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: mouse => {
            let menu = wallpaperWindow.globalMenu;
            if (!menu)
                return;
            mouse.accepted = true;
            if (mouse.button === Qt.RightButton) {
                menu.openAtPosition(wallpaperWindow, mouse.x, mouse.y, wallpaperWindow.desktopMenuStructure);
            } else if (mouse.button === Qt.LeftButton) {
                menu.close();
            }
        }
    }
}
