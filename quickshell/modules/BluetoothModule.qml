import QtQuick
import Quickshell.Bluetooth
import "../components/themeengine"

Item {
    id: bluetoothModule

    required property var globalMenu
    required property var parentWindow

    readonly property color disabledColor: ColorRegistry.bluetoothDisabledColor
    readonly property color disconnectedColor: ColorRegistry.bluetoothDisconnectedColor
    readonly property color connectedColor: ColorRegistry.bluetoothConnectedColor
    readonly property color labelColor: ColorRegistry.bluetoothLabelColor
    readonly property string labelFontFamily: TypographyRegistry.appliedFontFamily
    readonly property int labelFontSize: TypographyRegistry.appliedFontSize

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var devicesModel: Bluetooth.devices
    readonly property bool isBluetoothOn: adapter ? adapter.enabled : false

    implicitWidth: bluetoothRow.implicitWidth
    implicitHeight: bluetoothModule.parentWindow ? bluetoothModule.parentWindow.barHeight : 30

    property var currentMenuDevice: null
    property string pendingDeviceAddress: ""
    property string pendingDeviceState: ""
    property var ignoredDevices: []

    Connections {
        target: bluetoothModule.adapter ? bluetoothModule.adapter : null
        function onEnabledChanged() {
            bluetoothModule.updateMenu(false);
        }
        function onDiscoveringChanged() {
            if (bluetoothModule.adapter && bluetoothModule.adapter.discovering) {
                discoveryTimeoutTimer.restart();
            } else {
                discoveryTimeoutTimer.stop();
            }
            bluetoothModule.updateMenu(false);
        }
    }

    Timer {
        id: discoveryTimeoutTimer
        interval: 60000
        repeat: false
        onTriggered: {
            if (bluetoothModule.adapter && bluetoothModule.adapter.discovering) {
                bluetoothModule.adapter.discovering = false;
            }
        }
    }

    Timer {
        id: discoveryRefreshTimer
        interval: 5000
        repeat: true
        running: bluetoothModule.adapter && bluetoothModule.adapter.discovering && bluetoothModule.globalMenu && bluetoothModule.globalMenu.visible && bluetoothModule.currentMenuDevice === null
        onTriggered: {
            bluetoothModule.updateMenu(true);
        }
    }

    Timer {
        id: actionStateCheckTimer
        interval: 1000
        repeat: true
        running: bluetoothModule.pendingDeviceAddress !== "" && bluetoothModule.globalMenu && bluetoothModule.globalMenu.visible
        onTriggered: {
            bluetoothModule.updateMenu(true);
        }
    }

    function getConnectedDevice() {
        const list = devicesModel?.values ?? [];
        for (let i = 0; i < list.length; ++i) {
            const dev = list[i];
            if (dev?.connected && bluetoothModule.ignoredDevices.indexOf(dev.address) === -1)
                return dev;
        }
        return null;
    }

    function generateMainMenu() {
        let menuModel = [];
        if (!isBluetoothOn) {
            menuModel.push({
                text: "Ligar Bluetooth",
                onTrigger: () => {
                    if (adapter)
                        adapter.enabled = true;
                }
            });
            return menuModel;
        }

        menuModel.push({
            text: "Desligar Bluetooth",
            onTrigger: () => {
                if (adapter)
                    adapter.enabled = false;
            }
        });

        menuModel.push({
            text: adapter && adapter.discovering ? "Parar Busca" : "Iniciar Busca",
            preventClose: true,
            onTrigger: () => {
                if (adapter)
                    adapter.discovering = !adapter.discovering;
            }
        });

        const list = devicesModel?.values ?? [];
        let pairedDevices = [];
        let newDevices = [];

        for (let i = 0; i < list.length; i++) {
            let mainDev = list[i];
            if (!mainDev)
                continue;
            if (bluetoothModule.ignoredDevices.indexOf(mainDev.address) !== -1)
                continue;
            if (mainDev.paired) {
                pairedDevices.push(mainDev);
            } else if (adapter && adapter.discovering) {
                newDevices.push(mainDev);
            }
        }

        if (pairedDevices.length > 0) {
            menuModel.push({
                type: "separator"
            });
            for (let j = 0; j < pairedDevices.length; j++) {
                let pDev = pairedDevices[j];
                let label = (pDev.connected ? "! " : "? ") + (pDev.name || pDev.address);
                if (pDev.connected && pDev.batteryAvailable) {
                    label += ` (${Math.round(pDev.battery * 100)}%)`;
                }
                menuModel.push({
                    text: label,
                    preventClose: true,
                    onTrigger: () => {
                        openDeviceSubMenu(pDev);
                    }
                });
            }
        }

        if (newDevices.length > 0) {
            menuModel.push({
                type: "separator"
            });

            for (let k = 0; k < newDevices.length; k++) {
                let nDev = newDevices[k];
                menuModel.push({
                    text: "? " + (nDev.name || nDev.address),
                    preventClose: true,
                    onTrigger: () => {
                        openDeviceSubMenu(nDev);
                    }
                });
            }
        }

        return menuModel;
    }

    function generateDeviceMenu(dev) {
        let menuModel = [];
        if (!dev)
            return menuModel;

        let isConnecting = (bluetoothModule.pendingDeviceAddress === dev.address && bluetoothModule.pendingDeviceState === "connecting");
        let isDisconnecting = (bluetoothModule.pendingDeviceAddress === dev.address && bluetoothModule.pendingDeviceState === "disconnecting");

        if (isConnecting && dev.connected) {
            bluetoothModule.pendingDeviceAddress = "";
            bluetoothModule.pendingDeviceState = "";
            isConnecting = false;
        }
        if (isDisconnecting && !dev.connected) {
            bluetoothModule.pendingDeviceAddress = "";
            bluetoothModule.pendingDeviceState = "";
            isDisconnecting = false;
        }

        let connectText = "Conectar";
        if (isConnecting)
            connectText = "Conectando...";
        else if (isDisconnecting)
            connectText = "Desconectando...";
        else if (dev.connected)
            connectText = "Desconectar";

        menuModel.push({
            text: "Voltar ao Menu",
            preventClose: true,
            onTrigger: () => {
                bluetoothModule.currentMenuDevice = null;
                bluetoothModule.updateMenu(true);
            }
        });

        menuModel.push({
            text: `${dev.name || dev.address}`,
            enabled: false
        });

        menuModel.push({
            text: connectText,
            preventClose: true,
            onTrigger: () => {
                if (isConnecting || isDisconnecting)
                    return;

                if (dev.connected) {
                    bluetoothModule.pendingDeviceAddress = dev.address;
                    bluetoothModule.pendingDeviceState = "disconnecting";
                    dev.disconnect();
                } else {
                    bluetoothModule.pendingDeviceAddress = dev.address;
                    bluetoothModule.pendingDeviceState = "connecting";
                    dev.connect();
                }
                bluetoothModule.updateMenu(true);
            }
        });

        menuModel.push({
            text: dev.paired ? "Desparear" : "Parear",
            preventClose: true,
            onTrigger: () => {
                if (dev.paired) {
                    bluetoothModule.ignoredDevices.push(dev.address);
                    dev.forget();
                    bluetoothModule.currentMenuDevice = null;
                } else {
                    dev.pair();
                }
                bluetoothModule.updateMenu(true);
            }
        });

        menuModel.push({
            text: dev.trusted ? "Desconfiar" : "Confiar",
            preventClose: true,
            onTrigger: () => {
                dev.trusted = !dev.trusted;
                Qt.callLater(() => bluetoothModule.updateMenu(true));
            }
        });
        return menuModel;
    }

    function openDeviceSubMenu(dev) {
        bluetoothModule.currentMenuDevice = dev;
        bluetoothModule.updateMenu(true);
    }

    function updateMenu(forceOpen) {
        if (!bluetoothModule.globalMenu)
            return;

        if (forceOpen && !bluetoothModule.globalMenu.visible) {
            bluetoothModule.ignoredDevices = [];
            bluetoothModule.pendingDeviceAddress = "";
            bluetoothModule.pendingDeviceState = "";
        }

        if (!forceOpen && !bluetoothModule.globalMenu.visible)
            return;

        let modelData = [];
        if (bluetoothModule.currentMenuDevice !== null) {
            modelData = generateDeviceMenu(bluetoothModule.currentMenuDevice);
        } else {
            modelData = generateMainMenu();
        }
        bluetoothModule.globalMenu.showSearchInput = true;
        bluetoothModule.globalMenu.openMenu(bluetoothModule.parentWindow, bluetoothModule, modelData);
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: mouse => {
            let menu = bluetoothModule.globalMenu;
            if (menu) {
                menu.close();
            }
            mouse.accepted = true;
            if (mouse.button === Qt.LeftButton) {
                bluetoothModule.currentMenuDevice = null;
                bluetoothModule.updateMenu(true);
            } else if (mouse.button === Qt.RightButton) {
                if (bluetoothModule.adapter) {
                    bluetoothModule.adapter.enabled = !bluetoothModule.adapter.enabled;
                }
            }
        }
    }

    Row {
        id: bluetoothRow
        anchors.verticalCenter: parent.verticalCenter
        readonly property var btState: {
            if (!bluetoothModule.isBluetoothOn) {
                return {
                    color: bluetoothModule.disabledColor,
                    text: "off"
                };
            }
            const dev = bluetoothModule.getConnectedDevice();
            if (!dev) {
                return {
                    color: bluetoothModule.disconnectedColor,
                    text: "idle"
                };
            }
            if (dev.batteryAvailable) {
                const batPercent = Math.round(dev.battery * 100);
                return {
                    color: bluetoothModule.connectedColor,
                    text: `${dev.name} (${batPercent}%)`
                };
            }
            return {
                color: bluetoothModule.connectedColor,
                text: dev.name
            };
        }
        Text {
            id: btPrefix
            font.family: bluetoothModule.labelFontFamily
            font.pixelSize: bluetoothModule.labelFontSize
            color: bluetoothModule.labelColor
            text: "bt: "
        }
        Text {
            font: btPrefix.font
            color: bluetoothRow.btState.color
            text: bluetoothRow.btState.text
        }
    }
}
