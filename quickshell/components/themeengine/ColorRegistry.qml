pragma Singleton
import QtQuick
import "palettes"

QtObject {
    // AppLauncher
    property color appLauncherLabelColor: Gruvbox.light1
    // Mpris
    property color mprisPlayingColor: Gruvbox.neutral_aqua
    property color mprisPausedColor: Gruvbox.neutral_blue
    // Idle
    property color idleActivatedColor: Gruvbox.bright_aqua
    property color idleDeactivatedColor: Gruvbox.light4
    property color idleLabelColor: Gruvbox.light1
    // Microphone
    property color microphoneMutedColor: Gruvbox.bright_orange
    property color microphoneActiveColor: Gruvbox.bright_green
    property color microphoneLabelColor: Gruvbox.light1
    // Volume
    property color volumeMutedColor: Gruvbox.bright_orange
    property color volumeActiveColor: Gruvbox.bright_green
    property color volumeLabelColor: Gruvbox.light1
    // Clipboard
    property color clipboardUtilityColor: Gruvbox.neutral_purple
    // Bluetooth
    property color bluetoothDisabledColor: Gruvbox.bright_red
    property color bluetoothDisconnectedColor: Gruvbox.light4
    property color bluetoothConnectedColor: Gruvbox.neutral_blue
    property color bluetoothLabelColor: Gruvbox.light1
    // Network
    property color networkDisabledColor: Gruvbox.bright_red
    property color networkDisconnectedColor: Gruvbox.light4
    property color networkConnectedColor: Gruvbox.neutral_blue
    property color networkLabelColor: Gruvbox.light1
    // Backlight
    property color backlightBrightnessColor: Gruvbox.bright_yellow
    property color backlightLabelColor: Gruvbox.light1
    // Battery
    property color batteryErrorColor: Gruvbox.neutral_red
    property color batteryChargingColor: Gruvbox.bright_green
    property color batteryCriticalColor: Gruvbox.bright_red
    property color batteryLowColor: Gruvbox.bright_orange
    property color batteryNormalColor: Gruvbox.bright_yellow
    property color batteryLabelColor: Gruvbox.light1
    // Clock
    property color clockLabelColor: Gruvbox.light1
    property color clockDayColor: Gruvbox.bright_aqua
    property color clockMonthColor: Gruvbox.neutral_purple
    // Power
    property color powerSessionColor: Gruvbox.bright_blue
    // MainBar
    property color mainbarBackgroundColor: Gruvbox.dark0
    property color mainbarBorderColor: Gruvbox.dark1
    // ContextMenu
    property color menuBackgroundColor: Gruvbox.dark0
    property color menuBorderColor: Gruvbox.dark1
    property color menuTextHoverColor: Gruvbox.dark2
    property color menuTextColor: Gruvbox.light1
    property color menuHoverColor: Gruvbox.bright_orange
    // Notifications
    property color notificationBackgroundColor: Gruvbox.dark0
    property color notificationCriticalColor: Gruvbox.bright_red
    property color notificationLowColor: Gruvbox.bright_green
    property color notificationNormalColor: Gruvbox.dark1
    property color notificationContentColor: Gruvbox.light1
    // Lockscreen
    property color lockClockColor: Gruvbox.neutral_aqua
    property color lockLabelClockColor: Gruvbox.dark2
    property color lockHeaderAccentColor: Gruvbox.dark2
    property color lockPromptLabelColor: Gruvbox.neutral_yellow
    property color lockPromptInputActiveColor: Gruvbox.bright_aqua
    property color lockPromptInputInactiveColor: Gruvbox.neutral_aqua
    property color lockPromptErrorColor: Gruvbox.neutral_red
    property color lockScreenBackgroundColor: Gruvbox.dark0
}
