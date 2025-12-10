import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland

Text {
    id: layoutText
    property string currentLayout: "Tiled"

    text: currentLayout
    color: Theme.fg
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5

    Process {
        id: layoutProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    layoutText.currentLayout = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            layoutProc.running = true
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: layoutProc.running = true
    }
}
