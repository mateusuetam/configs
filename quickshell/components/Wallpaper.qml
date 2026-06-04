import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: wallpaperWindow

    readonly property url sourcePath: "file:/home/mateus/Imagens/afina.png"
    readonly property int imageFillMode: Image.Center

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

    Image {
        anchors.fill: parent
        source: wallpaperWindow.sourcePath
        fillMode: wallpaperWindow.imageFillMode
        asynchronous: true
        cache: true
    }
}
