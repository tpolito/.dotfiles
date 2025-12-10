import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: volText
    property int volumeLevel: 0

    text: "Vol: " + volumeLevel + "%"
    color: Theme.purple
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: pavuProc.running = true
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) {
                    volText.volumeLevel = Math.round(parseFloat(match[1]) * 100)
                }
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: pavuProc
        command: ["pavucontrol"]
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: volProc.running = true
    }
}
