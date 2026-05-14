import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: headphoneButton

    text: "󰋋"
    color: Theme.primary
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: connectProc.running = true
    }

    Process {
        id: connectProc
        command: ["bluetoothctl", "connect", "30:7A:D2:4E:9D:FB"]
    }
}
