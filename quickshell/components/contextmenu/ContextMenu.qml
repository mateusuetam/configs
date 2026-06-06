pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../themeengine"

PopupWindow {
    id: menuPopup

    readonly property color menuBackgroundColor: ColorRegistry.menuBackgroundColor
    readonly property color menuBorderColor: ColorRegistry.menuBorderColor
    readonly property color itemTextColor: ColorRegistry.menuTextColor
    readonly property color itemHoverColor: ColorRegistry.menuHoverColor
    readonly property color itemTextHoverColor: ColorRegistry.menuTextHoverColor
    readonly property string labelFontFamily: TypographyRegistry.appliedFontFamily

    readonly property int menuWidth: 200
    readonly property int itemHeight: 26
    readonly property int separatorHeight: 8
    readonly property int iconSize: 14
    readonly property int menuFontSize: 11
    readonly property int verticalOffset: 5
    readonly property int menuMargins: 6

    property var menuModel: null
    property var _pendingModel: null
    property var _pendingWindow: null
    property var _pendingAnchorItem: null

    property int _pendingX: 0
    property int _pendingY: 0

    readonly property var _self: menuPopup
    property bool _isAnchorMode: false
    readonly property bool _isDirectModel: menuPopup.menuModel !== null && (Array.isArray(menuPopup.menuModel) || typeof menuPopup.menuModel.rowCount === "function" || menuPopup.menuModel.count !== undefined)

    signal itemTriggered(var itemData)
    signal itemDataActionTriggered(string actionType, var data)

    implicitWidth: menuWidth
    implicitHeight: menuView.contentHeight + (menuMargins * 2)
    grabFocus: true

    onVisibleChanged: {
        if (!visible) {
            _self.anchor.window = null;
        }
    }

    function close() {
        visible = false;
    }

    function openMenu(targetWindow, anchorItem, modelData) {
        if (!anchorItem)
            return;

        _pendingModel = null;
        _pendingWindow = null;
        _pendingAnchorItem = null;
        visible = false;

        _pendingModel = modelData;
        _pendingWindow = targetWindow;
        _pendingAnchorItem = anchorItem;
        _isAnchorMode = true;

        repositionTimer.restart();
    }

    function openAtPosition(targetWindow, x, y, modelData) {
        if (!targetWindow)
            return;

        _pendingModel = null;
        _pendingWindow = null;
        _pendingAnchorItem = null;
        visible = false;

        _pendingModel = modelData;
        _pendingWindow = targetWindow;

        _pendingX = x;
        _pendingY = y;

        _isAnchorMode = false;

        repositionTimer.restart();
    }

    function handleItemTrigger(dataObj) {
        if (!dataObj)
            return;

        itemTriggered(dataObj);

        if (dataObj.actionType !== undefined) {
            itemDataActionTriggered(dataObj.actionType, dataObj.actionData);
        }

        if (typeof dataObj.onTrigger === "function") {
            dataObj.onTrigger();
        } else if (typeof dataObj.triggered === "function") {
            dataObj.triggered();
        } else if (typeof dataObj.trigger === "function") {
            dataObj.trigger();
        }

        if (dataObj.closeOnTrigger !== false && dataObj.preventClose !== true) {
            close();
        }
    }

    Timer {
        id: repositionTimer

        interval: 32
        repeat: false

        onTriggered: {
            if (!menuPopup._pendingWindow)
                return;

            menuPopup.menuModel = menuPopup._pendingModel;

            menuPopup._self.anchor.window = menuPopup._pendingWindow;

            if (menuPopup._isAnchorMode) {
                if (!menuPopup._pendingAnchorItem)
                    return;

                const windowPos = menuPopup._pendingAnchorItem.mapToItem(null, 0, menuPopup._pendingAnchorItem.height);

                const newX = windowPos.x - (menuPopup.implicitWidth / 2) + (menuPopup._pendingAnchorItem.width / 2);

                const newY = windowPos.y + menuPopup.verticalOffset;

                menuPopup._self.anchor.rect = Qt.rect(newX, newY, menuPopup._pendingAnchorItem.width, 1);
            } else {
                menuPopup._self.anchor.rect = Qt.rect(menuPopup._pendingX, menuPopup._pendingY, 1, 1);
            }

            menuPopup.visible = true;
        }
    }

    QsMenuOpener {
        id: menuOpener

        menu: menuPopup._isDirectModel ? null : menuPopup.menuModel
    }

    Rectangle {
        anchors.fill: parent

        color: menuPopup.menuBackgroundColor

        border.color: menuPopup.menuBorderColor
        border.width: 1

        ListView {
            id: menuView

            anchors.fill: parent
            anchors.margins: menuPopup.menuMargins

            spacing: 2

            interactive: false
            boundsBehavior: Flickable.StopAtBounds

            model: menuPopup._isDirectModel ? menuPopup.menuModel : menuOpener.children

            delegate: MenuItemDelegate {
                required property var model

                width: menuView.width

                menuPopup: menuPopup

                itemData: model.modelData !== undefined ? model.modelData : model

                onTriggered: dataObj => {
                    menuPopup.handleItemTrigger(dataObj);
                }
            }
        }
    }
}
