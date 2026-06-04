pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.Pam
import "../theme"

Item {
    id: lockRoot

    readonly property color lockBackgroundColor: "#282828"
    readonly property int screenMargins: 60
    readonly property int elementSpacing: 20

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: showFailure = false

    function activateLock() {
        currentText = "";
        showFailure = false;
        sessionLock.locked = true;
    }

    function tryUnlock() {
        if (currentText === "")
            return;
        lockRoot.unlockInProgress = true;
        pam.start();
    }

    PamContext {
        id: pam
        configDirectory: "pam"
        config: "password.conf"
        onPamMessage: if (this.responseRequired)
            this.respond(lockRoot.currentText)

        onCompleted: result => {
            if (result === PamResult.Success) {
                sessionLock.locked = false;
            } else {
                lockRoot.currentText = "";
                lockRoot.showFailure = true;
            }
            lockRoot.unlockInProgress = false;
        }
    }

    WlSessionLock {
        id: sessionLock

        WlSessionLockSurface {
            id: lockSurface
            color: lockRoot.lockBackgroundColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: lockRoot.screenMargins
                spacing: lockRoot.elementSpacing

                LockHeader {}

                LockClock {}

                Item {
                    Layout.fillHeight: true
                }

                LockPrompt {
                    id: lockPrompt
                    unlockInProgress: lockRoot.unlockInProgress
                    showFailure: lockRoot.showFailure
                    onTextChanged: val => lockRoot.currentText = val
                    onAccepted: lockRoot.tryUnlock()

                    Connections {
                        target: lockRoot
                        function onCurrentTextChanged() {
                            if (lockRoot.currentText === "") {
                                lockPrompt.clearText();
                            }
                        }
                    }
                }
            }
        }
    }
}
