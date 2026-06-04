import QtQuick

QtObject {
    id: helper

    readonly property int verticalOffset: 5

    function openMenu(menu, targetWindow, anchorItem, menuModel) {
        if (!menu || !anchorItem)
            return;
        menu.menuModel = menuModel;
        menu.anchor.window = targetWindow;
        const windowPos = anchorItem.mapToItem(null, 0, anchorItem.height);
        menu.anchor.rect.x = windowPos.x - (menu.implicitWidth / 2) + (anchorItem.width / 2);
        menu.anchor.rect.y = windowPos.y + helper.verticalOffset;
        menu.visible = true;
    }
}
