//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import "components"
import "components/lockscreen"

ShellRoot {
    id: shellScope

    IpcHandler {
        target: "lock_manager"
        function lock(): void {
            globalIdle.lockScreen();
        }
    }

    Wallpaper {
        screen: Quickshell.screens[0]
    }

    MainBar {
        id: mainBarWindow
        screen: Quickshell.screens[0]
    }

    NotificationPopup {
        targetWindow: mainBarWindow
    }

    IdleManager {
        id: globalIdle
        lockTarget: nativeLock
    }

    LockScreen {
        id: nativeLock
    }
}
