pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: sliderRoot

    required property var safeData
    required property var menuPopup
    required property bool isEnabled

    property real value: safeData.value !== undefined ? safeData.value : 0.5
    property real minValue: safeData.minValue !== undefined ? safeData.minValue : 0.0
    property real maxValue: safeData.maxValue !== undefined ? safeData.maxValue : 1.0

    opacity: sliderRoot.isEnabled ? 1.0 : 0.5

    function updateValueFromMouse(mouseX, trackWidth) {
        if (trackWidth <= 0 || !sliderRoot.isEnabled)
            return;

        const pct = Math.max(0.0, Math.min(1.0, mouseX / trackWidth));
        sliderRoot.value = sliderRoot.minValue + pct * (sliderRoot.maxValue - sliderRoot.minValue);

        if (typeof sliderRoot.safeData.onValueChanged === "function") {
            sliderRoot.safeData.onValueChanged(sliderRoot.value);
        }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        Item {
            width: parent.width
            height: parent.height

            Rectangle {
                id: trackBg
                width: parent.width
                height: 4
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.darker(sliderRoot.menuPopup.menuBorderColor, 1.2)
            }

            Rectangle {
                id: trackFill
                readonly property real range: sliderRoot.maxValue - sliderRoot.minValue
                readonly property real fillPct: range > 0 ? Math.max(0, Math.min(1, (sliderRoot.value - sliderRoot.minValue) / range)) : 0

                width: trackBg.width * fillPct
                height: 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: trackBg.left
                color: sliderRoot.menuPopup.itemTextHoverColor
            }

            Rectangle {
                width: 12
                height: 12
                anchors.verticalCenter: parent.verticalCenter
                x: Math.max(0, Math.min(trackBg.width - width, trackFill.width - (width / 2)))
                color: sliderRoot.menuPopup.itemTextColor
                border.color: sliderRoot.menuPopup.menuBackgroundColor
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
}
