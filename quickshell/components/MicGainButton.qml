import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: micGainButton

    text: "󰍬"
    color: Theme.secondary
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

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
}
