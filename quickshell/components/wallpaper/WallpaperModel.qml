pragma ComponentBehavior: Bound
import QtQuick
import QtQml
import Quickshell
import Qt.labs.folderlistmodel

Item {
    id: modelRoot

    property var subMenuStructure: []
    signal wallpaperSelected(url fileUrl)

    component WallpaperDelegate: QtObject {
        required property var model
        readonly property string name: model.fileName
        readonly property url urlPath: model.fileUrl
    }

    visible: false

    FolderListModel {
        id: folderModel

        folder: "file://" + Quickshell.env("HOME") + "/Imagens"
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
        showDirs: false
        showDotAndDotDot: false
        showOnlyReadable: true
    }

    Instantiator {
        id: fileInstantiator

        model: folderModel
        delegate: WallpaperDelegate {}
        onObjectAdded: rebuildDebounce.restart()
        onObjectRemoved: rebuildDebounce.restart()
    }

    Timer {
        id: rebuildDebounce

        interval: 32
        repeat: false
        onTriggered: modelRoot.rebuildMenu()
    }

    function rebuildMenu() {
        modelRoot.subMenuStructure = [];

        const list = [];
        for (var i = 0; i < fileInstantiator.count; i++) {
            const obj = fileInstantiator.objectAt(i) as WallpaperDelegate;

            if (!obj)
                continue;

            list.push({
                type: "action",
                text: obj.name,
                icon: "",
                enabled: true,
                preventClose: false,
                actionType: "change_wallpaper",
                actionData: obj.urlPath
            });
        }
        modelRoot.subMenuStructure = list;
    }
}
