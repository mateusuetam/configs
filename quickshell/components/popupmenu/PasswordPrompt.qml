pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../themeengine"

PopupWindow {
    id: passwordPopup

    readonly property color menuBackgroundColor: ColorRegistry.menuBackgroundColor
    readonly property color menuBorderColor: ColorRegistry.menuBorderColor
    readonly property color menuErrorColor: ColorRegistry.menuErrorColor
    readonly property color itemTextColor: ColorRegistry.menuTextColor
    readonly property string labelFontFamily: TypographyRegistry.appliedFontFamily
    readonly property int labelFontSize: TypographyRegistry.appliedFontSize

    property var targetNetwork: null
    property string statusState: "input"

    property var targetWindow: null
    property real targetX: 0
    property real targetY: 0

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
            if (passwordPopup.statusState !== "error") {
                passwordPopup.targetNetwork = null;
            }
        }
    }

    function openPrompt(network, parentWin) {
        if (!network || !parentWin)
            return;
        passwordPopup.targetNetwork = network;
        passwordPopup.targetWindow = parentWin;
        passwordPopup.targetX = (parentWin.width / 2) - (passwordPopup.implicitWidth / 2);
        passwordPopup.targetY = parentWin.height + 6;
        passwordPopup.visible = true;
    }

    Connections {
        target: passwordPopup.targetNetwork
        ignoreUnknownSignals: true
        function onConnectedChanged() {
            if (passwordPopup.targetNetwork && passwordPopup.targetNetwork.connected && passwordPopup.visible) {
                connectionWatchdog.stop();
                passwordPopup.visible = false;
                passwordPopup.targetNetwork = null;
            }
        }
    }

    Timer {
        id: connectionWatchdog
        interval: 10000
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
        color: passwordPopup.menuBackgroundColor
        border.color: passwordPopup.statusState === "error" ? passwordPopup.menuErrorColor : passwordPopup.menuBorderColor
        border.width: 1

        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 10

            Text {
                id: promptLabel
                anchors.verticalCenter: parent.verticalCenter
                font.family: passwordPopup.labelFontFamily
                font.pixelSize: passwordPopup.labelFontSize
                color: passwordPopup.statusState === "error" ? passwordPopup.menuErrorColor : passwordPopup.itemTextColor
                text: {
                    if (passwordPopup.statusState === "error")
                        return "Tente novamente:";
                    if (passwordPopup.statusState === "connecting")
                        return "Conectando a " + (passwordPopup.targetNetwork ? passwordPopup.targetNetwork.name : "") + "...";
                    return "Senha para " + (passwordPopup.targetNetwork ? passwordPopup.targetNetwork.name : "") + ":";
                }
            }

            TextInput {
                id: passwordInput
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - promptLabel.width - parent.spacing
                font.family: passwordPopup.labelFontFamily
                font.pixelSize: passwordPopup.labelFontSize
                color: passwordPopup.itemTextColor
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
