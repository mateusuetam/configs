pragma Singleton
import QtQuick
import "fonts"

QtObject {
    readonly property string appliedFontFamily: FontFamily.krypton
    readonly property int appliedFontSize: FontSize.normal
    readonly property int appliedHeaderFontSize: FontSize.medium
    readonly property int appliedMenuFontSize: FontSize.small
}
