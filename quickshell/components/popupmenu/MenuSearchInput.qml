pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: searchRoot

    required property var menuPopup

    width: parent ? parent.width : 200
    height: menuPopup.itemHeight + 8

    property alias inputHasFocus: textInput.focus
    property alias text: textInput.text

    function forceFocusNow() {
        textInput.forceActiveFocus();
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: Qt.darker(searchRoot.menuPopup.menuBackgroundColor, 1.15)
        border.color: searchRoot.menuPopup.menuBorderColor
        border.width: 1

        TextInput {
            id: textInput
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            verticalAlignment: TextInput.AlignVCenter
            font.family: searchRoot.menuPopup.labelFontFamily
            font.pixelSize: searchRoot.menuPopup.menuFontSize
            color: searchRoot.menuPopup.itemTextColor
            focus: true
            selectByMouse: true
            clip: true

            Keys.onPressed: event => {
                switch (event.key) {
                case Qt.Key_Down:
                case Qt.Key_Tab:
                    searchRoot.menuPopup.focusListView();
                    event.accepted = true;
                    break;
                case Qt.Key_Return:
                case Qt.Key_Enter:
                    const currentModel = searchRoot.menuPopup.getFilteredModel();
                    if (currentModel && currentModel.length > 0) {
                        const firstItem = currentModel[0];
                        const dataObj = firstItem.modelData !== undefined ? firstItem.modelData : firstItem;
                        searchRoot.menuPopup.handleItemTrigger(dataObj);
                    }
                    event.accepted = true;
                    break;
                }
            }
        }

        Text {
            anchors.fill: textInput
            anchors.leftMargin: textInput.anchors.leftMargin
            verticalAlignment: Text.AlignVCenter
            text: "Pesquisar..."
            font: textInput.font
            color: Qt.alpha(searchRoot.menuPopup.itemTextColor, 0.4)
            visible: textInput.text === ""
        }
    }
}
