import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland

Text {
    id: windowText
    property string activeWindow: "Window"

    text: activeWindow
    color: Theme.purple
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.fillWidth: true
    Layout.leftMargin: 8
    elide: Text.ElideRight
    maximumLineCount: 1

    Process {
        id: windowProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    windowText.activeWindow = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            windowProc.running = true
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: windowProc.running = true
    }
}
