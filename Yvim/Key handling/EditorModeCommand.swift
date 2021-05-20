import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode, KeyPressSimulator {
    let mode: Mode = .command

    weak var modeSwitcher: EditorModeSwitcher?
    let register: Register
    let editor: BufferEditor
    let commandMemory: CommandMemory

    lazy var reader = CompositeReader(createCommands())

    private var _pressKeys: [(CGKeyCode, CGEventFlags)] = []

    func simulateKeyPress(_ keyCode: CGKeyCode, _ flags: CGEventFlags) {
        _pressKeys.append((keyCode, flags))
    }

    func createCommands() -> [Reader] {
        [
            CommandModeMove(editor: editor, keySimulator: self, modeSwitcher: modeSwitcher),
            CommandModeDelete(register: register, commandMemory: commandMemory, editor: editor, modeSwitcher: modeSwitcher),
            CommandModeInsert(editor: editor, modeSwitcher: modeSwitcher),
            CommandModeVisual(modeSwitcher: modeSwitcher)
        ]
    }

    init(modeSwitcher: EditorModeSwitcher, register: Register, editor: BufferEditor, commandMemory: CommandMemory) {
        self.modeSwitcher = modeSwitcher
        self.register = register
        self.editor = editor
        self.commandMemory = commandMemory
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        guard keyEvent.event == .down else {
            return true
        }

        if reader.feed(character: keyEvent.key.char) {
            for key in _pressKeys { simulateKeyPress(key.0, key.1) }
            _pressKeys = []
            return true
        }

        modeSwitcher?.switchToCommandMode()
        return true
    }
}

protocol KeyPressSimulator: AnyObject {
    func simulateKeyPress(_ keyCode: CGKeyCode, _ flags: CGEventFlags) -> Void
}
