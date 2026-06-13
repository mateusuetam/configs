pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: delegateRoot

    required property var itemData

    property int itemHeight: 26
    property int separatorHeight: 8

    signal triggered(var dataObj)

    readonly property var safeData: delegateRoot.itemData || ({})

    readonly property bool isNativeSeparator: safeData.isSeparator !== undefined ? safeData.isSeparator : false
    readonly property bool isJSSeparator: safeData.type === "separator"
    readonly property bool isSeparator: isNativeSeparator || isJSSeparator
    readonly property bool isEnabled: safeData.enabled !== false && !isSeparator

    width: ListView.view ? ListView.view.width : 0
    height: isSeparator ? separatorHeight : itemHeight

    Component {
        id: actionComponent
        MenuAction {
            safeData: delegateRoot.safeData
            isEnabled: delegateRoot.isEnabled
            isCurrentKeyboardItem: !!delegateRoot.ListView.isCurrentItem
            onTriggered: dataObj => delegateRoot.triggered(dataObj)
        }
    }

    Component {
        id: separatorComponent
        MenuSeparator {}
    }

    Loader {
        anchors.fill: parent
        sourceComponent: delegateRoot.isSeparator ? separatorComponent : actionComponent
    }
}
