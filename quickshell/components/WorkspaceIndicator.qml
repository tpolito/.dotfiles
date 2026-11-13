import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    implicitWidth: childrenRect.width
    implicitHeight: parent.height

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            model: Hyprland.workspaces.values
                .filter(ws => ws.id > 0)
                .sort((a, b) => a.id - b.id)

            Rectangle {
                required property var modelData

                Layout.preferredWidth: 20
                Layout.preferredHeight: 30
                color: "transparent"

                property bool isActive: Hyprland.focusedWorkspace?.id === modelData.id

                Text {
                    text: modelData.id
                    color: Theme.primary
                    font.pixelSize: Theme.fontSize
                    font.family: Theme.fontFamily
                    font.bold: true
                    anchors.centerIn: parent
                }

                Rectangle {
                    width: 20
                    height: 3
                    color: parent.isActive ? Theme.secondary : Theme.bg
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData.id + " })")
                }
            }
        }
    }
}
