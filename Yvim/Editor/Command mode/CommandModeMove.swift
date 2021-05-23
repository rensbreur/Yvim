import Carbon.HIToolbox
import Foundation

class CommandModeMove: MotionCommand {
    let editor: BufferEditor
    weak var keySimulator: KeyPressSimulator?
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, keySimulator: KeyPressSimulator, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.keySimulator = keySimulator
        self.modeSwitcher = modeSwitcher
    }

    func handle(motion: LineMotion) {
        Operations.Move(motion: motion).perform(editor)
        modeSwitcher?.switchToCommandMode()
    }

    func handleUp() {
        keySimulator?.simulateKeyPress(CGKeyCode(kVK_UpArrow), [])
        modeSwitcher?.switchToCommandMode()
    }

    func handleDown() {
        keySimulator?.simulateKeyPress(CGKeyCode(kVK_DownArrow), [])
        modeSwitcher?.switchToCommandMode()
    }
}
