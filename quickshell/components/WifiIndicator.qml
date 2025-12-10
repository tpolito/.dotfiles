import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Row {
    id: wifiRow
    spacing: 4
    Layout.rightMargin: 8

    property string wifiSSID: ""
    property int wifiSignal: 0
    property bool wifiConnected: false

    Process {
        id: wifiProc
        command: ["sh", "-c", "nmcli -t -f ACTIVE,SSID,SIGNAL device wifi list | grep '^yes' | head -1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) {
                    wifiRow.wifiConnected = false
                    wifiRow.wifiSSID = ""
                    wifiRow.wifiSignal = 0
                    return
                }
                var parts = data.trim().split(':')
                if (parts.length >= 3) {
                    wifiRow.wifiConnected = true
                    wifiRow.wifiSSID = parts[1]
                    wifiRow.wifiSignal = parseInt(parts[2]) || 0
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: wifiProc.running = true
    }

    Text {
        id: wifiIcon
        text: !wifiRow.wifiConnected ? "󰤭" :
              wifiRow.wifiSignal >= 80 ? "󰤨" :
              wifiRow.wifiSignal >= 60 ? "󰤥" :
              wifiRow.wifiSignal >= 40 ? "󰤢" :
              wifiRow.wifiSignal >= 20 ? "󰤟" : "󰤯"
        color: Theme.cyan
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true
    }

    Text {
        id: ssidText
        text: wifiRow.wifiConnected ? wifiRow.wifiSSID : ""
        color: Theme.cyan
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true
    }
}
