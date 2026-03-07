import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland

Text {
    id: windowText
    property string activeWindow: "Window"
    property string clampedWindow: "Window"

    function clampWindowTitle(title) {
        const maxLength = 50
        if (!title) {
            return ""
        }
        if (title.length <= maxLength) {
            return title
        }
        return title.slice(0,maxLength) + '...'
    }

    text: clampedWindow
    color: Theme.secondary
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
                    var title = data.trim()
                    windowText.activeWindow = title
                    windowText.clampedWindow = windowText.clampWindowTitle(title)
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
