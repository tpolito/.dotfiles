import Quickshell
import "components"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            property var modelData
            screen: modelData
        }
    }
}