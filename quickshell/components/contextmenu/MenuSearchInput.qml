pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: searchRoot

    property var menuPopup: null

    width: parent ? parent.width : 200
    height: searchRoot.menuPopup ? searchRoot.menuPopup.itemHeight + 8 : 34

    property alias inputHasFocus: textInput.focus
    property alias text: textInput.text

    function forceFocusNow() {
        textInput.forceActiveFocus();
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: searchRoot.menuPopup ? Qt.darker(searchRoot.menuPopup.menuBackgroundColor, 1.15) : "#1a1a1a"
        border.color: searchRoot.menuPopup ? searchRoot.menuPopup.menuBorderColor : "#333"
        border.width: 1

        TextInput {
            id: textInput
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            verticalAlignment: TextInput.AlignVCenter
            font.family: searchRoot.menuPopup ? searchRoot.menuPopup.labelFontFamily : "sans"
            font.pixelSize: searchRoot.menuPopup ? searchRoot.menuPopup.menuFontSize : 11
            color: searchRoot.menuPopup ? searchRoot.menuPopup.itemTextColor : "#fff"
            focus: true
            selectByMouse: true
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Down) {
                    searchRoot.menuPopup.focusListView();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    let view = searchRoot.menuPopup.menuView;
                    if (view && view.model && view.model.length > 0) {
                        const firstItem = view.model[0];
                        const dataObj = firstItem.modelData !== undefined ? firstItem.modelData : firstItem;
                        searchRoot.menuPopup.handleItemTrigger(dataObj);
                    }
                    event.accepted = true;
                }
            }
        }

        Text {
            anchors.fill: textInput
            anchors.leftMargin: textInput.anchors.leftMargin
            verticalAlignment: Text.AlignVCenter
            text: "Pesquisar..."
            font: textInput.font
            color: searchRoot.menuPopup ? Qt.alpha(searchRoot.menuPopup.itemTextColor, 0.4) : "#888"
            visible: textInput.text === ""
        }
    }
}
