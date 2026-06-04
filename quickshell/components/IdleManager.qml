import QtQuick
import Quickshell.Wayland
import Quickshell.Io

Item {
    id: idleManager

    readonly property int lockTimeout: 300
    readonly property int screenTimeout: 600
    readonly property var monitorOffCommand: ["niri", "msg", "action", "power-off-monitors"]

    property bool enabledIdle: true
    property var lockTarget: null

    Process {
        id: screenProcess
        command: idleManager.monitorOffCommand
    }

    function lockScreen() {
        if (lockTarget != null) {
            lockTarget.activateLock();
        }
    }

    function turnOffMonitors() {
        screenProcess.startDetached();
    }

    IdleMonitor {
        id: lockMonitor
        timeout: idleManager.lockTimeout
        enabled: idleManager.enabledIdle
        respectInhibitors: true

        onIsIdleChanged: {
            if (isIdle)
                idleManager.lockScreen();
        }
    }

    IdleMonitor {
        id: screenMonitor
        timeout: idleManager.screenTimeout
        enabled: idleManager.enabledIdle
        respectInhibitors: true

        onIsIdleChanged: {
            if (isIdle)
                idleManager.turnOffMonitors();
        }
    }
}
