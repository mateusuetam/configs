pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: delegateRoot

    required property var itemData
    required property var menuPopup

    signal triggered(var dataObj)

    readonly property var safeData: delegateRoot.itemData || ({})
    readonly property bool isEnabled: safeData.enabled !== false

    readonly property string itemType: {
        const type = safeData.type;
        const validTypes = ["action", "separator", "submenu", "toggle", "slider"];
        if (validTypes.indexOf(type) !== -1)
            return type;
        return safeData.isSeparator ? "separator" : "action";
    }

    readonly property bool isSeparator: itemType === "separator"
    readonly property bool isAction: itemType === "action"
    readonly property bool isSubmenu: itemType === "submenu"
    readonly property bool isToggle: itemType === "toggle"
    readonly property bool isSlider: itemType === "slider"

    width: parent ? parent.width : 0
    height: isSeparator ? menuPopup.separatorHeight : (isSlider ? menuPopup.itemHeight * 1.5 : menuPopup.itemHeight)

    Component {
        id: actionComponent
        MenuAction {
            safeData: delegateRoot.safeData
            menuPopup: delegateRoot.menuPopup
            isEnabled: delegateRoot.isEnabled
            isSubmenu: delegateRoot.isSubmenu
            isToggle: delegateRoot.isToggle
            isCurrentKeyboardItem: delegateRoot.ListView.isCurrentItem
            onTriggered: dataObj => delegateRoot.triggered(dataObj)
        }
    }

    Component {
        id: separatorComponent
        MenuSeparator {
            menuPopup: delegateRoot.menuPopup
        }
    }

    Component {
        id: sliderComponent
        MenuSlider {
            safeData: delegateRoot.safeData
            menuPopup: delegateRoot.menuPopup
            isEnabled: delegateRoot.isEnabled
        }
    }

    Loader {
        anchors.fill: parent
        sourceComponent: {
            if (delegateRoot.isSeparator)
                return separatorComponent;
            if (delegateRoot.isSlider)
                return sliderComponent;
            return actionComponent;
        }
    }
}
