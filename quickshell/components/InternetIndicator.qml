import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Row {
    id: internetRow
    spacing: 4
    Layout.rightMargin: 8

    property bool ethernetConnected: false
    property string ethernetName: ""

    property bool wifiConnected: false
    property string wifiSSID: ""
    property int wifiSignal: 0

    readonly property bool online: ethernetConnected || wifiConnected
    readonly property bool usingEthernet: ethernetConnected

    Process {
        id: ethernetProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE,CONNECTION device status | grep '^ethernet:connected' | head -1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) {
                    internetRow.ethernetConnected = false
                    internetRow.ethernetName = ""
                    return
                }
                var parts = data.trim().split(':')
                internetRow.ethernetConnected = true
                internetRow.ethernetName = parts.length >= 3 ? parts[2] : ""
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: wifiProc
        command: ["sh", "-c", "nmcli -t -f ACTIVE,SSID,SIGNAL device wifi list | grep '^yes' | head -1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) {
                    internetRow.wifiConnected = false
                    internetRow.wifiSSID = ""
                    internetRow.wifiSignal = 0
                    return
                }
                var parts = data.trim().split(':')
                if (parts.length >= 3) {
                    internetRow.wifiConnected = true
                    internetRow.wifiSSID = parts[1]
                    internetRow.wifiSignal = parseInt(parts[2]) || 0
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            ethernetProc.running = true
            wifiProc.running = true
        }
    }

    Process {
        id: nmConnectionEditor
        command: ["nm-connection-editor"]
    }

    Text {
        id: connectionIcon
        text: internetRow.usingEthernet ? "󰈀" :
              !internetRow.wifiConnected ? "󰤭" :
              internetRow.wifiSignal >= 80 ? "󰤨" :
              internetRow.wifiSignal >= 60 ? "󰤥" :
              internetRow.wifiSignal >= 40 ? "󰤢" :
              internetRow.wifiSignal >= 20 ? "󰤟" : "󰤯"
        color: Theme.primary
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true
    }

    Text {
        id: connectionLabel
        text: internetRow.usingEthernet ? internetRow.ethernetName :
              internetRow.wifiConnected ? internetRow.wifiSSID : ""
        color: Theme.primary
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true

        MouseArea {
            anchors.fill: parent
            onClicked: nmConnectionEditor.running = true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
