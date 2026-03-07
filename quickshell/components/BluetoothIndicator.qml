import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: bluetoothIcon

    text: ""
    color: Theme.primary
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: bluetoothProc.running = true
    }

    Process {
        id: bluetoothProc
        command: [
            "sh",
            "-c",
            "${TERMINAL:-} -e bluetui 2>/dev/null || " +
            "command -v ghostty >/dev/null 2>&1 && ghostty -e bluetui"
        ]
    }
}
