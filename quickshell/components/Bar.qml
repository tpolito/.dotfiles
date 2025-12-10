import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    required property var screen

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: Theme.bg

    margins {
        top: 0
        bottom: 0
        left: 0
        right: 0
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg

        // Left section
        RowLayout {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            spacing: 0

            Item { width: Theme.spacing }

            WorkspaceIndicator {}

            Separator {}

            LayoutIndicator {}

            Separator {
                Layout.leftMargin: 2
            }

            ActiveWindow {}
        }

        // Center section - absolutely centered
        ClockWidget {
            anchors.centerIn: parent
        }

        // Right section
        RowLayout {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            spacing: 0

            // KernelInfo {}

            // Separator {
            //     Layout.leftMargin: 0
            // }

            CpuIndicator {}

            Separator {
                Layout.leftMargin: 0
            }

            MemoryIndicator {}

            Separator {
                Layout.leftMargin: 0
            }

            DiskIndicator {}

            Separator {
                Layout.leftMargin: 0
            }

            VolumeIndicator {}

            Separator {
                Layout.leftMargin: 0
            }

            WifiIndicator {}

            Item { width: Theme.spacing }
        }
    }
}
