import QtQuick
import Quickshell.Wayland
import "../core"

Item {
id: idleModule

required property var globalMenu
required property var parentWindow

readonly property color activatedColor: ThemeRegistry.idleActivatedColor
readonly property color deactivatedColor: ThemeRegistry.idleDeactivatedColor
readonly property string labelFontFamily: ThemeRegistry.appliedFontFamily
readonly property int labelFontSize: ThemeRegistry.appliedFontSize

readonly property bool isActive: inhibitor.enabled

implicitWidth: idleRow.implicitWidth
implicitHeight: idleModule.parentWindow ? idleModule.parentWindow.barHeight : 30

IdleInhibitor {
id: inhibitor
window: idleModule.parentWindow
enabled: false
}

MouseArea {
anchors.fill: parent
cursorShape: Qt.PointingHandCursor
acceptedButtons: Qt.LeftButton
onPressed: mouse => {
let menu = idleModule.globalMenu;
if (menu) {
menu.close();
}
mouse.accepted = true;
if (mouse.button === Qt.LeftButton) {
inhibitor.enabled = !inhibitor.enabled;
}
}
}

Row {
id: idleRow
anchors.verticalCenter: parent.verticalCenter
readonly property var idleState: {
return idleModule.isActive ? {
color: idleModule.activatedColor,
text: "ACTIVE"
} : {
color: idleModule.deactivatedColor,
text: "IDLING"
};
}
Text {
font.family: idleModule.labelFontFamily
font.pixelSize: idleModule.labelFontSize
color: idleRow.idleState.color
text: idleRow.idleState.text
}
}
}
