import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: micText
    property string micLevel: "N/A"

    text: "Mic: " + micLevel
    color: Theme.secondary
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    Process {
        id: micProc
        command: [
            "bash", "-c",
            "node_id=$(wpctl status 2>/dev/null | grep 'Elgato Wave 3 Mono' | grep -oP '\\d+(?=\\. Elgato Wave 3 Mono)' | head -1); " +
            "[ -n \"$node_id\" ] && wpctl get-volume \"$node_id\" 2>/dev/null || echo 'N/A'"
        ]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) {
                    micText.micLevel = Math.round(parseFloat(match[1]) * 100) + "%"
                } else if (data.trim() === "N/A") {
                    micText.micLevel = "N/A"
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: micProc.running = true
    }
}
