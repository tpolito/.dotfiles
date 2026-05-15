pragma Singleton
import QtQuick

QtObject {
    // Color scheme
    readonly property color bg: "#000000"
    readonly property color fg: "#ffffff"
    readonly property color muted: "#333333"
    readonly property color primary: "#ffffff"
    readonly property color secondary: "#cccccc"
    readonly property color alert: "#ffffff"
    readonly property color warning: "#aaaaaa"
    readonly property color info: "#888888"

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 14

    // Bar dimensions
    readonly property int barHeight: 45
    readonly property int spacing: 8
}
