pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import QtCore

PanelWindow {
    id: wallpaperWindow

    required property var globalMenu
    property var focusWindow: null

    property url sourcePath: wallpaperSettings.savedPath
    readonly property int imageFillMode: Image.PreserveAspectCrop

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "wallpaper"

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }
    exclusiveZone: -1
    focusable: false

    Settings {
        id: wallpaperSettings
        location: "file://" + Quickshell.env("HOME") + "/Documentos/repos/configs/quickshell/components/wallpaper/wallpaper_settings.conf"
        category: "Wallpaper"
        property url savedPath: ""
    }

    property WallpaperModel backendModel: WallpaperModel {
        id: backendModel
        onWallpaperSelected: fileUrl => {
            wallpaperSettings.savedPath = fileUrl;
        }
    }

    Connections {
        target: wallpaperWindow.globalMenu
        function onItemDataActionTriggered(actionType, data) {
            switch (actionType) {
            case "open_wallpaper_submenu":
                wallpaperWindow.globalMenu.menuModel = backendModel.subMenuStructure;
                break;
            case "change_wallpaper":
                backendModel.wallpaperSelected(data);
                break;
            }
        }

        function onVisibleChanged() {
            if (wallpaperWindow.globalMenu && !wallpaperWindow.globalMenu.visible) {
                if (!wallpaperWindow.globalMenu._isInternalReset) {
                    wallpaperWindow.focusable = false;
                }
            }
        }
    }

    readonly property var desktopMenuStructure: [
        {
            type: "action",
            text: "Trocar Wallpaper",
            icon: "",
            preventClose: true,
            actionType: "open_wallpaper_submenu",
            actionData: null
        }
    ]

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

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
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: mouse => {
            let menu = wallpaperWindow.globalMenu;
            if (!menu)
                return;
            mouse.accepted = true;
            if (mouse.button === Qt.RightButton) {
                wallpaperWindow.focusable = true;
                menu.showSearchInput = false;
                menu.openAtPosition(wallpaperWindow, mouse.x, mouse.y, wallpaperWindow.desktopMenuStructure);
            } else if (mouse.button === Qt.LeftButton) {
                menu.close();
            }
        }
    }
}
