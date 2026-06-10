import QtQuick
import Quickshell.Io
import "../components/themeengine"

Item {
    id: powermenuModule

    required property var globalMenu
    required property var parentWindow

    readonly property color sessionColor: ColorRegistry.powerSessionColor
    readonly property string labelFontFamily: TypographyRegistry.appliedFontFamily
    readonly property int labelFontSize: TypographyRegistry.appliedFontSize

    readonly property var powerMenuModel: [
        {
            type: "action",
            text: "Sair",
            onTrigger: () => cmdSair.startDetached()
        },
        {
            type: "action",
            text: "Bloquear",
            onTrigger: () => cmdBloquear.startDetached()
        },
        {
            type: "separator"
        },
        {
            type: "action",
            text: "Suspender",
            onTrigger: () => cmdSuspender.startDetached()
        },
        {
            type: "action",
            text: "Reiniciar",
            onTrigger: () => cmdReiniciar.startDetached()
        },
        {
            type: "action",
            text: "Desligar",
            onTrigger: () => cmdDesligar.startDetached()
        }
    ]

    implicitWidth: powerRow.implicitWidth
    implicitHeight: powermenuModule.parentWindow ? powermenuModule.parentWindow.barHeight : 30

    Process {
        id: cmdSair
        command: ["niri", "msg", "action", "quit", "--skip-confirmation"]
    }
    Process {
        id: cmdBloquear
        command: ["quickshell", "ipc", "call", "lock_manager", "lock"]
    }
    Process {
        id: cmdSuspender
        command: ["systemctl", "suspend"]
    }
    Process {
        id: cmdReiniciar
        command: ["reboot"]
    }
    Process {
        id: cmdDesligar
        command: ["shutdown", "-h", "0"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onPressed: mouse => {
            let menu = powermenuModule.globalMenu;
            if (menu) {
                menu.close();
            }
            mouse.accepted = true;
            if (mouse.button === Qt.LeftButton) {
                if (menu) {
                    menu.openMenu(powermenuModule.parentWindow, powermenuModule, powermenuModule.powerMenuModel);
                }
            }
        }
    }

    Row {
        id: powerRow
        anchors.verticalCenter: parent.verticalCenter
        Text {
            font.family: powermenuModule.labelFontFamily
            font.pixelSize: powermenuModule.labelFontSize
            color: powermenuModule.sessionColor
            text: "[SESS]"
        }
    }
}
