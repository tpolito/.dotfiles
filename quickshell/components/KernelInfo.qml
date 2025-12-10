import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: kernelText
    property string kernelVersion: "Linux"

    text: kernelVersion
    color: Theme.red
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    Process {
        id: kernelProc
        command: ["uname", "-r"]
        stdout: SplitParser {
            onRead: data => {
                if (data) kernelText.kernelVersion = data.trim()
            }
        }
        Component.onCompleted: running = true
    }
}
