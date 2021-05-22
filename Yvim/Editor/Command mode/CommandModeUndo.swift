import Foundation

class CommandModeUndo: EditorCommand {
    weak var keySimulator: KeyPressSimulator?
    weak var modeSwitcher: EditorModeSwitcher?

    init(keySimulator: KeyPressSimulator?, modeSwitcher: EditorModeSwitcher?) {
        self.keySimulator = keySimulator
        self.modeSwitcher = modeSwitcher
    }

    func handleEvent() {
        /// The undo comand simply simulates a command + z keypress.
        /// Having a seperate undo mechanism will interfere with the standard one, which might be
        /// annoying.
        keySimulator?.simulateKeyPress(keycodeForString("z"), [.maskCommand])
        modeSwitcher?.switchToCommandMode()
    }

}
