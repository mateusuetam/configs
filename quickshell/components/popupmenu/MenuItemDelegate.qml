pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: delegateRoot

    required property var itemData
    property int itemHeight: 26
    property int separatorHeight: 8

    signal triggered(var dataObj)

    readonly property var safeData: delegateRoot.itemData || ({})
    readonly property bool isSeparator: (safeData.isSeparator !== undefined ? safeData.isSeparator : false) || (safeData.type === "separator")
    readonly property bool isEnabled: safeData.enabled !== false && !isSeparator

    width: ListView.view ? ListView.view.width : 0
    height: isSeparator ? separatorHeight : itemHeight

    MenuSeparator {
        anchors.fill: parent
        visible: delegateRoot.isSeparator
    }

    MenuAction {
        anchors.fill: parent
        visible: !delegateRoot.isSeparator
        safeData: delegateRoot.safeData
        isEnabled: delegateRoot.isEnabled
        isCurrentKeyboardItem: !!delegateRoot.ListView.isCurrentItem
        onTriggered: dataObj => delegateRoot.triggered(dataObj)
    }
}
