import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: cpuText
    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    text: "CPU: " + cpuUsage + "%"
    color: Theme.yellow
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var user = parseInt(parts[1]) || 0
                var nice = parseInt(parts[2]) || 0
                var system = parseInt(parts[3]) || 0
                var idle = parseInt(parts[4]) || 0
                var iowait = parseInt(parts[5]) || 0
                var irq = parseInt(parts[6]) || 0
                var softirq = parseInt(parts[7]) || 0

                var total = user + nice + system + idle + iowait + irq + softirq
                var idleTime = idle + iowait

                if (cpuText.lastCpuTotal > 0) {
                    var totalDiff = total - cpuText.lastCpuTotal
                    var idleDiff = idleTime - cpuText.lastCpuIdle
                    if (totalDiff > 0) {
                        cpuText.cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
                    }
                }
                cpuText.lastCpuTotal = total
                cpuText.lastCpuIdle = idleTime
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }
}
