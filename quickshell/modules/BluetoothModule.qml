import QtQuick
import Quickshell.Io
import Quickshell.Bluetooth
import "../components/theme"

Item {
    id: bluetoothModule

    readonly property color disabledColor: "#fb4934"
    readonly property color disconnectedColor: "#928374"
    readonly property color connectedColor: "#458588"
    readonly property color labelColor: "#ebdbb2"

    readonly property bool isBluetoothOn: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false

    implicitWidth: bluetoothText.implicitWidth
    implicitHeight: 30

    function getConnectedDevice() {
        var devicesList = Bluetooth.devices.values;
        if (!devicesList)
            return null;

        for (var i = 0; i < devicesList.length; i++) {
            var dev = devicesList[i];
            if (dev && dev.connected) {
                return dev;
            }
        }
        return null;
    }

    Process {
        id: btMenu
        command: ["sh", "-c", "$HOME/Documentos/repos/configs/scripts/blue.sh"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                btMenu.running = true;
            } else if (mouse.button === Qt.RightButton) {
                if (Bluetooth.defaultAdapter) {
                    Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                }
            }
        }
    }

    Text {
        id: bluetoothText

        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        anchors.verticalCenter: parent.verticalCenter

        textFormat: Text.RichText

        color: {
            if (!bluetoothModule.isBluetoothOn) {
                return bluetoothModule.disabledColor;
            }

            var dev = bluetoothModule.getConnectedDevice();
            if (!dev) {
                return bluetoothModule.disconnectedColor;
            }

            return bluetoothModule.connectedColor;
        }

        text: {
            var prefix = `<span style="color: ${bluetoothModule.labelColor};">bt:</span>`;

            if (!bluetoothModule.isBluetoothOn) {
                return `${prefix} off`;
            }

            var dev = bluetoothModule.getConnectedDevice();
            if (!dev) {
                return `${prefix} unpaired`;
            }

            if (dev.batteryAvailable) {
                var batPercent = Math.round(dev.battery * 100);
                return `${prefix} ${dev.name} (${batPercent}%)`;
            }

            return `${prefix} ${dev.name}`;
        }
    }
}
