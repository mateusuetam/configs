pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: delegateRoot

    required property var itemData

    property int itemHeight: 26
    property int separatorHeight: 8

    signal triggered(var dataObj)

    readonly property var safeData: delegateRoot.itemData || ({})
    readonly property bool isEnabled: safeData.enabled !== false

    readonly property string itemType: {
        const type = safeData.type;
        const validTypes = ["action", "separator", "submenu", "toggle", "slider"];
        if (validTypes.includes(type))
            return type;
        return safeData.isSeparator ? "separator" : "action";
    }

    readonly property bool isSeparator: itemType === "separator"
    readonly property bool isSlider: itemType === "slider"
    readonly property bool isSubmenu: itemType === "submenu"
    readonly property bool isToggle: itemType === "toggle"

    width: ListView.view ? ListView.view.width : 0
    height: isSeparator ? separatorHeight : (isSlider ? itemHeight * 1.5 : itemHeight)

    Component {
        id: actionComponent
        MenuAction {
            safeData: delegateRoot.safeData
            isEnabled: delegateRoot.isEnabled
            isSubmenu: delegateRoot.isSubmenu
            isToggle: delegateRoot.isToggle
            isCurrentKeyboardItem: delegateRoot.ListView.isCurrentItem
            onTriggered: dataObj => delegateRoot.triggered(dataObj)
        }
    }

    Component {
        id: separatorComponent
        MenuSeparator {}
    }

    Component {
        id: sliderComponent
        MenuSlider {
            safeData: delegateRoot.safeData
            isEnabled: delegateRoot.isEnabled
        }
    }

    Loader {
        anchors.fill: parent
        sourceComponent: {
            if (delegateRoot.isSeparator)
                return separatorComponent;
            // ativar a renderização visual do Slider:
            // if (delegateRoot.isSlider) return sliderComponent;
            return actionComponent;
        }
    }
}
