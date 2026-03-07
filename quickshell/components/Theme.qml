pragma Singleton
import QtQuick

QtObject {
    // Color scheme
    readonly property color bg: "#1c1e1a"
    readonly property color fg: "#ffffff"
    readonly property color muted: "#3d4038"
    readonly property color primary: "#8fb573"
    readonly property color secondary: "#9caa8c"
    readonly property color alert: "#f7768e"
    readonly property color warning: "#d4b876"
    readonly property color info: "#7ba3a3"

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 14

    // Bar dimensions
    readonly property int barHeight: 45
    readonly property int spacing: 8
}
