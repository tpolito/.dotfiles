import QtQuick
import QtQuick.Layouts

Text {
    id: clockText
    text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    color: Theme.cyan
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    }
}
