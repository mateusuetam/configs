pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../core"

PopupWindow {
id: passwordPopup

property var targetNetwork: null
property string statusState: "input"
property var targetWindow: null

property real targetX: targetWindow ? (targetWindow.width / 2) - (implicitWidth / 2) : 0
property real targetY: targetWindow ? targetWindow.height + 6 : 0

implicitWidth: 440
implicitHeight: 40
grabFocus: true

anchor.window: passwordPopup.targetWindow
anchor.rect: Qt.rect(passwordPopup.targetX, passwordPopup.targetY, 1, 1)

onVisibleChanged: {
if (visible) {
passwordPopup.statusState = "input";
passwordInput.text = "";
Qt.callLater(() => {
passwordInput.forceActiveFocus();
});
} else {
connectionWatchdog.stop();
passwordPopup.targetNetwork = null;
}
}

function openPrompt(network, parentWin) {
if (!network || !parentWin)
return;

passwordPopup.targetNetwork = network;
passwordPopup.targetWindow = parentWin;
passwordPopup.visible = true;
}

Connections {
target: passwordPopup.targetNetwork
ignoreUnknownSignals: true
function onConnectedChanged() {
if (passwordPopup.targetNetwork?.connected && passwordPopup.visible) {
connectionWatchdog.stop();
passwordPopup.visible = false;
passwordPopup.targetNetwork = null;
}
}
}

Timer {
id: connectionWatchdog
interval: 5000
repeat: false
onTriggered: {
if (passwordPopup.targetNetwork && !passwordPopup.targetNetwork.connected) {
passwordPopup.statusState = "error";
passwordInput.text = "";
passwordInput.forceActiveFocus();
}
}
}

Rectangle {
anchors.fill: parent
color: ThemeRegistry.menuBackgroundColor
border.color: passwordPopup.statusState === "error" ? ThemeRegistry.menuErrorColor : ThemeRegistry.menuBorderColor
border.width: 1

RowLayout {
anchors.fill: parent
anchors.margins: 8
spacing: 10

Text {
id: promptLabel
Layout.alignment: Qt.AlignVCenter
font.family: ThemeRegistry.appliedFontFamily
font.pixelSize: ThemeRegistry.appliedFontSize
color: passwordPopup.statusState === "error" ? ThemeRegistry.menuErrorColor : ThemeRegistry.menuTextColor
text: {
if (passwordPopup.statusState === "error")
return "Tente novamente:";

const netName = passwordPopup.targetNetwork?.name || "";

if (passwordPopup.statusState === "connecting")
return `Conectando a ${netName}...`;

return `Senha para ${netName}:`;
}
}

TextInput {
id: passwordInput
Layout.alignment: Qt.AlignVCenter
Layout.fillWidth: true
font.family: ThemeRegistry.appliedFontFamily
font.pixelSize: ThemeRegistry.appliedFontSize
color: ThemeRegistry.menuTextColor
echoMode: TextInput.Password
selectByMouse: true
clip: true
visible: passwordPopup.statusState !== "connecting"

Keys.onPressed: event => {
if (event.key === Qt.Key_Escape) {
passwordPopup.visible = false;
event.accepted = true;
} else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
if (passwordPopup.targetNetwork && passwordInput.text.length > 0) {
passwordPopup.statusState = "connecting";
passwordPopup.targetNetwork.connectWithPsk(passwordInput.text);
connectionWatchdog.start();
} else {
passwordPopup.visible = false;
}
event.accepted = true;
}
}
}
}
}
}
