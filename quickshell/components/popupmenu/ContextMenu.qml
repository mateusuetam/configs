pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../themeengine"

PopupWindow {
    id: menuPopup

    readonly property color menuBackgroundColor: ColorRegistry.menuBackgroundColor
    readonly property color menuBorderColor: ColorRegistry.menuBorderColor

    readonly property int menuWidth: 200
    readonly property int itemHeight: 26
    readonly property int separatorHeight: 8
    readonly property int verticalOffset: 5
    readonly property int menuMargins: 6
    readonly property int menuMaxHeight: 450

    property bool showSearchInput: false
    property string filterText: ""
    property var menuModel: null
    property var _pendingModel: null
    property var _pendingWindow: null
    property var _pendingAnchorItem: null
    property int _pendingX: 0
    property int _pendingY: 0
    property bool _isAnchorMode: false
    property bool _isInternalReset: false

    readonly property alias menuView: menuView
    readonly property bool _isDirectModel: menuPopup.menuModel !== null && (Array.isArray(menuPopup.menuModel) || typeof menuPopup.menuModel.rowCount === "function" || menuPopup.menuModel.count !== undefined)
    readonly property var _unfilteredModel: menuPopup._isDirectModel ? menuPopup.menuModel : menuOpener.children
    property var _currentFilteredModel: []

    onFilterTextChanged: _updateFilteredModel()

    signal itemTriggered(var itemData)
    signal itemDataActionTriggered(string actionType, var data)

    implicitWidth: menuWidth
    implicitHeight: Math.min((menuPopup.showSearchInput ? searchLoader.height + 4 : 0) + menuView.contentHeight + (menuMargins * 2), menuMaxHeight)
    grabFocus: true

    onVisibleChanged: {
        if (visible) {
            if (showSearchInput) {
                Qt.callLater(() => {
                    if (searchLoader.item) {
                        searchLoader.item.forceFocusNow();
                    }
                });
            } else {
                Qt.callLater(() => {
                    menuBackground.forceActiveFocus();
                });
            }
        } else {
            if (!_isInternalReset) {
                if (searchLoader.item) {
                    searchLoader.item.text = "";
                }
                menuPopup.showSearchInput = false;
                menuPopup.filterText = "";
                menuPopup.anchor.window = null;
            }
        }
    }

    function close() {
        visible = false;
    }

    function openMenu(targetWindow, anchorItem, modelData) {
        if (!anchorItem)
            return;
        _prepareToOpen(targetWindow, modelData);
        _pendingAnchorItem = anchorItem;
        _isAnchorMode = true;
        repositionTimer.restart();
    }

    function openAtPosition(targetWindow, x, y, modelData) {
        if (!targetWindow)
            return;
        _prepareToOpen(targetWindow, modelData);
        _pendingX = x;
        _pendingY = y;
        _isAnchorMode = false;
        repositionTimer.restart();
    }

    function _prepareToOpen(targetWindow, modelData) {
        repositionTimer.stop();
        _pendingAnchorItem = null;
        menuPopup.menuModel = null;
        menuPopup.filterText = "";
        if (searchLoader.item)
            searchLoader.item.text = "";

        _isInternalReset = true;
        visible = false;
        _isInternalReset = false;

        _pendingModel = modelData;
        _pendingWindow = targetWindow;
    }

    function handleItemTrigger(dataObj) {
        if (!dataObj || dataObj.enabled === false || dataObj.isSeparator || dataObj.type === "separator")
            return;

        itemTriggered(dataObj);
        if (dataObj.actionType !== undefined) {
            itemDataActionTriggered(dataObj.actionType, dataObj.actionData);
        }

        if (typeof dataObj.onTrigger === 'function')
            dataObj.onTrigger();
        else if (typeof dataObj.triggered === 'function')
            dataObj.triggered();
        else if (typeof dataObj.trigger === 'function')
            dataObj.trigger();

        if (dataObj.closeOnTrigger !== false && dataObj.preventClose !== true) {
            close();
        }
    }

    function _applyPositioning() {
        if (!_pendingWindow)
            return;

        menuPopup.menuModel = _pendingModel;
        menuPopup.anchor.window = _pendingWindow;

        if (_isAnchorMode) {
            if (!_pendingAnchorItem)
                return;
            const windowPos = _pendingAnchorItem.mapToItem(null, 0, _pendingAnchorItem.height);
            const newX = windowPos.x - (implicitWidth / 2) + (_pendingAnchorItem.width / 2);
            const newY = windowPos.y + verticalOffset;
            menuPopup.anchor.rect = Qt.rect(newX, newY, _pendingAnchorItem.width, 1);
        } else {
            menuPopup.anchor.rect = Qt.rect(_pendingX, _pendingY, 1, 1);
        }
        menuPopup.visible = true;
    }

    QsMenuOpener {
        id: menuOpener
        menu: menuPopup._isDirectModel ? null : menuPopup.menuModel
    }

    function _updateFilteredModel() {
        const search = menuPopup.filterText.toLowerCase().trim();
        if (search === "")
            return;

        const rawSource = menuPopup._isDirectModel ? menuPopup.menuModel : menuOpener.children;
        if (!rawSource) {
            menuPopup._currentFilteredModel = [];
            return;
        }

        const itemsArray = Array.from(rawSource);
        menuPopup._currentFilteredModel = itemsArray.filter(item => {
            let textToMatch = "";
            if (item && typeof item === 'object') {
                if (item.text !== undefined)
                    textToMatch = item.text;
                else if (item.name !== undefined)
                    textToMatch = item.name;
                else if (item.label !== undefined)
                    textToMatch = item.label;
                else if (item.modelData !== undefined && item.modelData.text !== undefined)
                    textToMatch = item.modelData.text;
            } else if (typeof item === 'string') {
                textToMatch = item;
            }
            return textToMatch.toLowerCase().includes(search);
        });
    }

    function focusListView() {
        if (menuView.currentIndex === -1 && menuView.count > 0) {
            menuView.currentIndex = 0;
        }
        menuView.forceActiveFocus();
    }

    Timer {
        id: repositionTimer
        interval: 32
        repeat: false
        onTriggered: menuPopup._applyPositioning()
    }

    Rectangle {
        id: menuBackground
        anchors.fill: parent
        color: menuPopup.menuBackgroundColor
        border.color: menuPopup.menuBorderColor
        border.width: 1
        focus: true

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: mouse => {
                menuBackground.forceActiveFocus();
                mouse.accepted = false;
            }
        }

        Keys.onPressed: event => {
            switch (event.key) {
            case Qt.Key_Escape:
                menuPopup.close();
                event.accepted = true;
                break;
            case Qt.Key_Tab:
                if (menuPopup.showSearchInput && searchLoader.item) {
                    searchLoader.item.forceFocusNow();
                }
                event.accepted = true;
                break;
            case Qt.Key_Up:
                if (menuView.currentIndex <= 0) {
                    menuView.currentIndex = menuView.count - 1;
                } else {
                    menuView.decrementCurrentIndex();
                }
                event.accepted = true;
                break;
            case Qt.Key_Down:
                if (menuView.currentIndex === -1 || menuView.currentIndex === menuView.count - 1) {
                    menuView.currentIndex = 0;
                } else {
                    menuView.incrementCurrentIndex();
                }
                event.accepted = true;
                break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if (menuView.currentIndex >= 0 && menuView.currentItem) {
                    const dataObj = menuView.currentItem.itemData;
                    if (dataObj) {
                        menuPopup.handleItemTrigger(dataObj);
                    }
                }
                event.accepted = true;
                break;
            }
        }

        Loader {
            id: searchLoader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: menuPopup.menuMargins
            anchors.bottomMargin: 0
            visible: menuPopup.showSearchInput
            active: menuPopup.showSearchInput
            sourceComponent: searchInputComponent
            onLoaded: {
                if (item) {
                    item.forceFocusNow();
                    item.textChanged.connect(() => {
                        menuPopup.filterText = item.text;
                    });
                    item.navigationDownRequested.connect(() => {
                        menuPopup.focusListView();
                    });
                    item.actionTriggeredRequested.connect(() => {
                        if (menuView.count > 0) {
                            const targetItem = menuView.currentItem ? menuView.currentItem : menuView.itemAtIndex(0);
                            if (targetItem && targetItem.itemData) {
                                menuPopup.handleItemTrigger(targetItem.itemData);
                            }
                        }
                    });
                }
            }
        }

        Component {
            id: searchInputComponent
            MenuSearchInput {
                itemHeight: menuPopup.itemHeight
            }
        }

        ListView {
            id: menuView
            anchors.top: searchLoader.visible ? searchLoader.bottom : parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: menuPopup.menuMargins
            anchors.topMargin: searchLoader.visible ? 4 : menuPopup.menuMargins
            highlightMoveDuration: 0
            spacing: 2
            interactive: true
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            currentIndex: -1
            onModelChanged: currentIndex = -1
            highlightFollowsCurrentItem: true
            model: menuPopup.filterText.trim() === "" ? menuPopup._unfilteredModel : menuPopup._currentFilteredModel
            delegate: MenuItemDelegate {
                required property var model
                width: menuView.width
                itemHeight: menuPopup.itemHeight
                separatorHeight: menuPopup.separatorHeight
                itemData: model.modelData !== undefined ? model.modelData : model
                onTriggered: dataObj => menuPopup.handleItemTrigger(dataObj)
            }
            MouseArea {
                z: -1
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: mouse => {
                    menuBackground.forceActiveFocus();
                    mouse.accepted = false;
                }
            }
        }
    }
}
