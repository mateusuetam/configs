pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../components/themeengine"

Item {
    id: appLauncherModule

    required property var globalMenu
    required property var parentWindow

    readonly property color utilityColor: ColorRegistry.appLauncherLabelColor
    readonly property string labelFontFamily: TypographyRegistry.appliedFontFamily
    readonly property int labelFontSize: TypographyRegistry.appliedFontSize

    implicitWidth: launcherRow.implicitWidth
    implicitHeight: appLauncherModule.parentWindow ? appLauncherModule.parentWindow.barHeight : 30

    property var _tempModel: []

    Instantiator {
        id: appsInstantiator
        model: DesktopEntries.applications
        delegate: QtObject {
            required property var modelData
            readonly property string appName: modelData ? (modelData.name || "") : ""
            readonly property bool appNoDisplay: modelData ? (modelData.noDisplay || false) : false
            function launch() {
                if (modelData && typeof modelData.execute === "function")
                    modelData.execute();
            }
        }
    }

    function generateAppList() {
        let processedModel = [];
        let totalApps = appsInstantiator.count;
        for (let i = 0; i < totalApps; i++) {
            let item = appsInstantiator.objectAt(i);
            if (!item || item.appNoDisplay || item.appName === "")
                continue;
            processedModel.push({
                text: item.appName,
                onTrigger: () => {
                    if (item && typeof item.launch === "function")
                        item.launch();
                }
            });
        }
        processedModel.sort((a, b) => a.text.localeCompare(b.text));
        return processedModel;
    }

    function refreshAndOpenApps() {
        appLauncherModule._tempModel = appLauncherModule.generateAppList();
        if (appLauncherModule._tempModel.length > 0 && appLauncherModule.globalMenu) {
            appLauncherModule.globalMenu.showSearchInput = true;
            appLauncherModule.globalMenu.openMenu(appLauncherModule.parentWindow, appLauncherModule, appLauncherModule._tempModel);
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onPressed: mouse => {
            let menu = appLauncherModule.globalMenu;
            if (menu) {
                menu.close();
            }
            mouse.accepted = true;
            appLauncherModule.refreshAndOpenApps();
        }
    }

    Row {
        id: launcherRow
        anchors.verticalCenter: parent.verticalCenter
        Text {
            font.family: appLauncherModule.labelFontFamily
            font.pixelSize: appLauncherModule.labelFontSize
            color: appLauncherModule.utilityColor
            text: "[APPS]"
        }
    }
}
