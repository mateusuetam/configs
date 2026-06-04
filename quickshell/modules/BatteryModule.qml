import QtQuick
import Quickshell.Services.UPower
import "../components/theme"

Text {
    id: batteryModule

    readonly property color errorColor: "#cc241d"
    readonly property color chargingColor: "#b8bb26"
    readonly property color criticalColor: "#fb4934"
    readonly property color lowColor: "#fe8019"
    readonly property color normalColor: "#fabd2f"

    readonly property var dev: UPower.displayDevice
    readonly property int realPercentage: (dev && dev.ready) ? Math.round(dev.percentage * 100) : 0
    readonly property bool isFull: dev ? (dev.state === UPowerDeviceState.FullyCharged || (realPercentage >= 95 && dev.changeRate === 0)) : false

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    anchors.verticalCenter: parent.verticalCenter

    color: {
        if (!dev || !dev.ready)
            return batteryModule.errorColor;
        if (!UPower.onBattery)
            return batteryModule.chargingColor;
        if (realPercentage <= 20)
            return batteryModule.criticalColor;
        if (realPercentage <= 30)
            return batteryModule.lowColor;
        return batteryModule.normalColor;
    }

    text: {
        if (!dev || !dev.ready)
            return "bat: --%";
        if (!UPower.onBattery) {
            return isFull ? `bat: ${realPercentage}% [AC]` : `bat: ${realPercentage}% +${Math.round(Math.abs(dev.changeRate))}W`;
        }
        return `bat: ${realPercentage}% - ${Math.round(Math.abs(dev.changeRate))}W`;
    }
}
