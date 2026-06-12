pragma ComponentBehavior: Bound
import QtQuick
import "../themeengine"

Item {
    id: sliderRoot

    readonly property color menuBorderColor: ColorRegistry.menuBorderColor
    readonly property color menuBackgroundColor: ColorRegistry.menuBackgroundColor
    readonly property color itemTextColor: ColorRegistry.menuTextColor
    readonly property color itemTextHoverColor: ColorRegistry.menuTextHoverColor

    required property var safeData
    required property bool isEnabled

    property real value: safeData.value !== undefined ? safeData.value : 0.5
    property real minValue: safeData.minValue !== undefined ? safeData.minValue : 0.0
    property real maxValue: safeData.maxValue !== undefined ? safeData.maxValue : 1.0

    opacity: sliderRoot.isEnabled ? 1.0 : 0.5

    function updateValueFromMouse(mouseX, trackWidth) {
        if (trackWidth <= 0 || !sliderRoot.isEnabled)
            return;

        const pct = Math.max(0.0, Math.min(1.0, mouseX / trackWidth));
        const rawValue = sliderRoot.minValue + pct * (sliderRoot.maxValue - sliderRoot.minValue);
        const cleanedValue = Math.round(rawValue * 100) / 100;

        if (sliderRoot.value !== cleanedValue) {
            sliderRoot.value = cleanedValue;
            if (typeof sliderRoot.safeData.onValueChanged === "function") {
                sliderRoot.safeData.onValueChanged(sliderRoot.value);
            }
        }
    }

    Item {
        id: trackContainer
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12

        Rectangle {
            id: trackBg
            width: parent.width
            height: 4
            anchors.verticalCenter: parent.verticalCenter
            color: Qt.darker(sliderRoot.menuBorderColor, 1.2)
        }

        Rectangle {
            id: trackFill
            readonly property real range: sliderRoot.maxValue - sliderRoot.minValue
            readonly property real fillPct: range > 0 ? Math.max(0, Math.min(1, (sliderRoot.value - sliderRoot.minValue) / range)) : 0
            width: trackBg.width * fillPct
            height: 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: trackBg.left
            color: sliderRoot.itemTextHoverColor
        }

        Rectangle {
            width: 12
            height: 12
            anchors.verticalCenter: parent.verticalCenter
            x: Math.max(0, Math.min(trackBg.width - width, trackFill.width - (width / 2)))
            color: sliderRoot.itemTextColor
            border.color: sliderRoot.menuBackgroundColor
            border.width: 1
        }

        MouseArea {
            anchors.fill: parent
            enabled: sliderRoot.isEnabled
            cursorShape: Qt.PointingHandCursor
            onPressed: mouse => sliderRoot.updateValueFromMouse(mouse.x, width)
            onPositionChanged: mouse => sliderRoot.updateValueFromMouse(mouse.x, width)
        }
    }
}
