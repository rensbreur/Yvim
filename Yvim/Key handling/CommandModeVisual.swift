import Foundation

class CommandModeVisual: EditorCommand {
    weak var modeSwitcher: EditorModeSwitcher?

    init(modeSwitcher: EditorModeSwitcher?) {
        self.modeSwitcher = modeSwitcher
    }

    func handleEvent() {
        modeSwitcher?.switchToVisualMode(selection: nil)
    }
}
