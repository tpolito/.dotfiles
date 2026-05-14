import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Text {
    id: windowText

    function clampWindowTitle(title) {
        const maxLength = 50
        if (!title) {
            return ""
        }
        if (title.length <= maxLength) {
            return title
        }
        return title.slice(0, maxLength) + '...'
    }

    text: clampWindowTitle(Hyprland.activeToplevel?.title ?? "")
    color: Theme.secondary
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true
    Layout.fillWidth: true
    Layout.leftMargin: 8
    elide: Text.ElideRight
    maximumLineCount: 1
}
