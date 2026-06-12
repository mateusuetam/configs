pragma Singleton
import QtQuick
import "palettes"

QtObject {
    // AppLauncher
    readonly property color appLauncherSeparatorColor: Gruvbox.light1
    readonly property color appLauncherLabelColor: Gruvbox.bright_blue
    // Mpris
    readonly property color mprisPlayingColor: Gruvbox.neutral_aqua
    readonly property color mprisPausedColor: Gruvbox.neutral_blue
    // Idle
    readonly property color idleActivatedColor: Gruvbox.bright_aqua
    readonly property color idleDeactivatedColor: Gruvbox.light4
    readonly property color idleLabelColor: Gruvbox.light1
    // Microphone
    readonly property color microphoneMutedColor: Gruvbox.bright_orange
    readonly property color microphoneActiveColor: Gruvbox.bright_green
    readonly property color microphoneLabelColor: Gruvbox.light1
    // Volume
    readonly property color volumeMutedColor: Gruvbox.bright_orange
    readonly property color volumeActiveColor: Gruvbox.bright_green
    readonly property color volumeLabelColor: Gruvbox.light1
    // Clipboard
    readonly property color clipboardLabelColor: Gruvbox.neutral_purple
    // Bluetooth
    readonly property color bluetoothDisabledColor: Gruvbox.bright_red
    readonly property color bluetoothDisconnectedColor: Gruvbox.light4
    readonly property color bluetoothConnectedColor: Gruvbox.neutral_blue
    readonly property color bluetoothLabelColor: Gruvbox.light1
    // Network
    readonly property color networkDisabledColor: Gruvbox.bright_red
    readonly property color networkDisconnectedColor: Gruvbox.light4
    readonly property color networkConnectedColor: Gruvbox.neutral_blue
    readonly property color networkLabelColor: Gruvbox.light1
    // Backlight
    readonly property color backlightBrightnessColor: Gruvbox.bright_yellow
    readonly property color backlightLabelColor: Gruvbox.light1
    // Battery
    readonly property color batteryErrorColor: Gruvbox.neutral_red
    readonly property color batteryChargingColor: Gruvbox.bright_green
    readonly property color batteryCriticalColor: Gruvbox.bright_red
    readonly property color batteryLowColor: Gruvbox.bright_orange
    readonly property color batteryNormalColor: Gruvbox.bright_yellow
    readonly property color batteryLabelColor: Gruvbox.light1
    // Clock
    readonly property color clockLabelColor: Gruvbox.light1
    readonly property color clockDayColor: Gruvbox.bright_aqua
    readonly property color clockMonthColor: Gruvbox.neutral_purple
    // Power
    readonly property color powerSessionSeparatorColor: Gruvbox.light1
    readonly property color powerSessionLabelColor: Gruvbox.bright_orange
    // MainBar
    readonly property color mainbarBackgroundColor: Gruvbox.dark0
    readonly property color mainbarBorderColor: Gruvbox.dark1
    // Menu
    readonly property color menuBackgroundColor: Gruvbox.dark0
    readonly property color menuBorderColor: Gruvbox.dark1
    readonly property color menuTextHoverColor: Gruvbox.dark2
    readonly property color menuTextColor: Gruvbox.light1
    readonly property color menuHoverColor: Gruvbox.bright_orange
    readonly property color menuErrorColor: Gruvbox.bright_red
    // Notifications
    readonly property color notificationBackgroundColor: Gruvbox.dark0
    readonly property color notificationCriticalColor: Gruvbox.bright_red
    readonly property color notificationLowColor: Gruvbox.bright_green
    readonly property color notificationNormalColor: Gruvbox.dark1
    readonly property color notificationContentColor: Gruvbox.light1
    // Lockscreen
    readonly property color lockClockColor: Gruvbox.neutral_aqua
    readonly property color lockLabelClockColor: Gruvbox.dark2
    readonly property color lockHeaderAccentColor: Gruvbox.dark2
    readonly property color lockPromptLabelColor: Gruvbox.neutral_yellow
    readonly property color lockPromptInputActiveColor: Gruvbox.bright_aqua
    readonly property color lockPromptInputInactiveColor: Gruvbox.neutral_aqua
    readonly property color lockPromptErrorColor: Gruvbox.neutral_red
    readonly property color lockScreenBackgroundColor: Gruvbox.dark0
}
