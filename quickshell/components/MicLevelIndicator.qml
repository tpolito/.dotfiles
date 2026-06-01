import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: micText
    property string micLevel: "N/A"
    property bool maxed: micLevel === "100%"

    text: "Mic: " + micLevel
    color: maxed ? "#ff3b3b" : Theme.secondary
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    transform: Translate { id: shakeT }
    SequentialAnimation {
        running: micText.maxed
        loops: Animation.Infinite
        onStopped: shakeT.x = 0
        NumberAnimation { target: shakeT; property: "x"; from: 0; to: -2; duration: 40 }
        NumberAnimation { target: shakeT; property: "x"; from: -2; to: 2; duration: 40 }
        NumberAnimation { target: shakeT; property: "x"; from: 2; to: 0; duration: 40 }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: micGainProc.running = true
    }

    Process {
        id: micGainProc
        command: [
            "bash", "-c",
            "node_id=$(wpctl status 2>/dev/null | grep 'Elgato Wave 3 Mono' | grep -oP '\\d+(?=\\. Elgato Wave 3 Mono)' | head -1); " +
            "[ -n \"$node_id\" ] && wpctl set-volume \"$node_id\" 0.40"
        ]
    }

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
