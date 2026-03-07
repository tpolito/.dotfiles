import Quickshell
import QtQml
import "components"

ShellRoot {
    Variants {
        model: Quickshell.screens
        
        delegate: Component {
            Bar {
                required property var modelData
                screen: modelData
            }
        }
    }
}
