import Foundation

class CommandModeVisual: EditorCommand {
    weak var modeSwitcher: EditorModeSwitcher?

    init(modeSwitcher: EditorModeSwitcher?) {
        self.modeSwitcher = modeSwitcher
    }

    let reader: Reader = SimpleReader(character: KeyConstants.visual)

    func handleEvent() {
        modeSwitcher?.switchToVisualMode(selection: nil)
    }
}
