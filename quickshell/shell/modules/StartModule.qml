pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../core"

Item {
id: startModule

required property var globalMenu
required property var parentWindow

readonly property color sLabelColor: ThemeRegistry.sLabelColor
readonly property color t1LabelColor: ThemeRegistry.t1LabelColor
readonly property color aLabelColor: ThemeRegistry.aLabelColor
readonly property color rLabelColor: ThemeRegistry.rLabelColor
readonly property color t2LabelColor: ThemeRegistry.t2LabelColor
readonly property color separatorColor: ThemeRegistry.startSeparatorColor
readonly property string labelFontFamily: ThemeRegistry.appliedFontFamily
readonly property int labelFontSize: ThemeRegistry.appliedFontSize

implicitWidth: startRow.implicitWidth
implicitHeight: startModule.parentWindow ? startModule.parentWindow.barHeight : 30

readonly property var powerMenuModel: [
{
type: "action",
text: "< Menu de Apps",
onTrigger: () => startModule.openAppMenu()
},
{ type: "separator" },
{
type: "action",
text: "Sair",
onTrigger: () => Quickshell.execDetached(["niri", "msg", "action", "quit", "--skip-confirmation"])
},
{
type: "action",
text: "Bloquear",
onTrigger: () => Quickshell.execDetached(["quickshell", "ipc", "call", "lock_manager", "lock"])
},
{ type: "separator" },
{
type: "action",
text: "Suspender",
onTrigger: () => Quickshell.execDetached(["systemctl", "suspend"])
},
{
type: "action",
text: "Reiniciar",
onTrigger: () => Quickshell.execDetached(["reboot"])
},
{
type: "action",
text: "Desligar",
onTrigger: () => Quickshell.execDetached(["shutdown", "-h", "0"])
}
]

Instantiator {
id: appsInstantiator
model: DesktopEntries.applications
delegate: QtObject {
id: appDelegate
required property var modelData
readonly property string appName: modelData ? (modelData.name || "") : ""
readonly property bool appNoDisplay: modelData ? (modelData.noDisplay || false) : false

function launch() {
if (modelData && modelData.command && modelData.command.length > 0) {
Quickshell.execDetached({
command: modelData.command,
workingDirectory: modelData.workingDirectory || ""
});
}
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
type: "action",
text: item.appName,
onTrigger: () => {
if (item && typeof item.launch === "function")
item.launch();
}
});
}

processedModel.sort((a, b) => a.text.localeCompare(b.text));

processedModel.push({ type: "separator" });
processedModel.push({
type: "action",
text: "< Menu de Sessão",
onTrigger: () => startModule.openSessionMenu()
});

return processedModel;
}

function openAppMenu() {
let appModel = generateAppList();
if (appModel.length > 0 && startModule.globalMenu) {
startModule.globalMenu.showSearchInput = true;
startModule.globalMenu.openMenu(startModule.parentWindow, startModule, appModel);
}
}

function openSessionMenu() {
if (startModule.globalMenu) {
startModule.globalMenu.showSearchInput = false;
startModule.globalMenu.openMenu(startModule.parentWindow, startModule, startModule.powerMenuModel);
}
}

MouseArea {
anchors.fill: parent
cursorShape: Qt.PointingHandCursor
acceptedButtons: Qt.LeftButton
onPressed: mouse => {
let menu = startModule.globalMenu;
if (menu) {
menu.close();
}
mouse.accepted = true;
startModule.openAppMenu();
}
}

Row {
id: startRow
anchors.verticalCenter: parent.verticalCenter
Text {
id: prefixText
font.family: startModule.labelFontFamily
font.pixelSize: startModule.labelFontSize
color: startModule.separatorColor
text: "["
}
Text { font: prefixText.font; color: startModule.sLabelColor; text: "S" }
Text { font: prefixText.font; color: startModule.t1LabelColor; text: "T" }
Text { font: prefixText.font; color: startModule.aLabelColor; text: "A" }
Text { font: prefixText.font; color: startModule.rLabelColor; text: "R" }
Text { font: prefixText.font; color: startModule.t2LabelColor; text: "T" }
Text { font: prefixText.font; color: prefixText.color; text: "]" }
}
}
